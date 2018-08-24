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

    public static var configuration = Configuration()

    private static let redirectURI = "com.kylebashour.Wooly://oath2"

    private static var currentClient: Client?
    private static var currentService: Service?
    private static weak var currentViewController: AuthenticatorViewController?

    public static func handle(url: URL) -> Bool {
        var token: String?

        defer {
            currentViewController?.dismiss(animated: true)
            if let client = currentClient {
                currentViewController?.didAuthenticate(client: client, with: token)
            }
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let firstItem = components.queryItems?.first, firstItem.name == "code" else {
                return false
        }

        token = firstItem.value
        return true
    }

    private static func service(for instance: String) -> Service {
        let service = Service(baseURL: "https://\(instance)/api/v1", standardTransformers: [])
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        service.configureTransformer("apps") {
            try decoder.decode(Client.self, from: $0.content)
        }
        return service
    }

    static func performOauth(client: Client, for instance: String, from viewController: AuthenticatorViewController) {
        self.currentViewController = viewController
        let parameters = [
            URLQueryItem(name: "scope", value: "read write follow"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "client_id", value: client.clientId)
        ]

        var components = URLComponents(string: "https://\(instance)/oauth/authorize")!
        components.queryItems = parameters
        let safariViewController = SFSafariViewController(url: components.url!)
        safariViewController.preferredBarTintColor = configuration.barTintColor
        safariViewController.preferredControlTintColor = configuration.controlTintColor
        safariViewController.dismissButtonStyle = .cancel
        safariViewController.modalPresentationStyle = .overFullScreen
        viewController.present(safariViewController, animated: true, completion: nil)
    }

    public static func authenticate(on instance: String, from viewController: AuthenticatorViewController,
                                    completion: @escaping (Bool) -> Void) {
        let app = App(clientName: "Wooly", redirectURI: redirectURI)
        currentService = service(for: instance)
        currentService?.resource("apps").request(.post, json: app.dictionary ?? [:]).onSuccess { entity in
            guard let client: Client = entity.typedContent() else {
                return completion(false)
            }

            self.currentClient = client
            performOauth(client: client, for: instance, from: viewController)
            completion(true)
        } .onFailure {
            print($0)
        }
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
