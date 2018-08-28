import UIKit
import Siesta
import SafariServices

public protocol Authenticator {
    func didAuthenticate(client: Client, with token: String?)
}

public typealias AuthenticatorViewController = UIViewController & Authenticator

public enum HandshakeService {
    public struct Configuration {
        public var barTintColor: UIColor?
        public var controlTintColor: UIColor?
    }

    private struct Handshake {
        var app: App?
        weak var viewController: AuthenticatorViewController?

        var client: Client?
        var service: Service?
    }

    private static var currentHandshake = Handshake()

    public static var configuration = Configuration()

    public static func handle(url: URL) -> Bool {
        var token: String?

        defer {
            currentHandshake.viewController?.dismiss(animated: true)
            if let client = currentHandshake.client {
                currentHandshake.viewController?.didAuthenticate(client: client, with: token)
            }
            cleanup()
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let firstItem = components.queryItems?.first, firstItem.name == "code" else {
                return false
        }

        token = firstItem.value
        return true
    }

    private static func service(for instance: Instance) -> Service {
        let service = Service(baseURL: instance.url.appendingPathComponent("api/v1"), standardTransformers: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        service.configureTransformer("apps") {
            try decoder.decode(Client.self, from: $0.content)
        }
        return service
    }

    private static func performOauth(client: Client, for instance: Instance) {
        let parameters = [
            URLQueryItem(name: "scope", value: "read write follow"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: currentHandshake.app?.redirectUris),
            URLQueryItem(name: "client_id", value: client.clientId)
        ]

        var components = URLComponents(url: instance.url.appendingPathComponent("oauth/authorize"), resolvingAgainstBaseURL: true)!
        components.queryItems = parameters
        let safariViewController = SFSafariViewController(url: components.url!)
        safariViewController.preferredBarTintColor = configuration.barTintColor
        safariViewController.preferredControlTintColor = configuration.controlTintColor
        safariViewController.dismissButtonStyle = .cancel
        safariViewController.modalPresentationStyle = .overFullScreen
        currentHandshake.viewController?.present(safariViewController, animated: true, completion: nil)
    }

    public static func authenticate(app: App, on instance: Instance, from viewController: AuthenticatorViewController,
                                    completion: @escaping (Bool) -> Void) {
        currentHandshake = Handshake(app: app, viewController: viewController, client: nil, service: nil)
        currentHandshake.viewController = viewController
        currentHandshake.service = service(for: instance)
        currentHandshake.service?.resource("apps").request(.post, json: app.dictionary ?? [:]).onSuccess { entity in
            guard let client: Client = entity.typedContent() else {
                cleanup()
                return completion(false)
            }

            currentHandshake.client = client
            performOauth(client: client, for: instance)
            completion(true)
        } .onFailure { error in
            cleanup()
            print("--- Handshake failed: \(error)")
        }
    }

    private static func cleanup() {
        currentHandshake = Handshake()
    }
}

private extension Encodable {
    var dictionary: [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
