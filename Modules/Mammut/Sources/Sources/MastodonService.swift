import Foundation
import Keychain
import Siesta

public class MastodonService: Service {
    enum InitializationError: Error {
        case invalidInstanceURL
    }

    private let instanceURL: URL
    private let client: Client
    private let authKeychain: Keychain
    private let refreshToken: String

    private var authenticationToken: String? {
        get {
            return (try? authKeychain.password()) ?? nil
        }
        set {
            try? authKeychain.set(password: newValue)
            invalidateConfiguration()
            wipeResources()
        }
    }

    private var authenticationData: [String: Any] {
        return [
            "client_id": client.clientId,
            "client_secret": client.clientSecret,
            "code": refreshToken,
            "redirect_uri": "com.kylebashour.Wooly://oath2",
            "grant_type": "authorization_code"
        ]
    }

    public var home: Resource {
        return resource("timelines/home")
    }

    /// Create a new service
    ///
    /// - Parameter instanceURL: The URL of the Mastodon instance (i.e., `mastodon.social`)
    public init(session: Session) throws {
        self.client = session.client
        self.refreshToken = session.refreshToken
        self.instanceURL = try URL(string: "https://\(session.instanceURL)") ?? {
            throw InitializationError.invalidInstanceURL
        }()
        self.authKeychain = Keychain(service: instanceURL.absoluteString, account: "auth-token")

        super.init(baseURL: instanceURL.url?.appendingPathComponent("api/v1"), standardTransformers: [.text, .image])

        configureHeaders()
        configureTransformers()
    }

    private func configureHeaders() {
        configure("**") {
            $0.headers["Authorization"] = self.authenticationToken
            $0.headers["Content-Type"] = "application/json; charset=utf-8"

            $0.decorateRequests { resource, request in
                request.chained {
                    guard case .failure(let error) = $0.response,
                        error.httpStatusCode == 401 else {
                            return .useThisResponse
                    }

                    return .passTo(self.createAuthToken().chained {
                        if case .failure = $0.response {
                            return .useThisResponse
                        } else {
                            return .passTo(request.repeated())
                        }
                    })
                }
            }
        }
    }

    private func configureTransformers() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        configureTransformer("timelines/*") {
            try decoder.decode([Status].self, from: $0.content)
        }
    }

    private func createAuthToken() -> Request {
        return resource(baseURL: instanceURL, path: "oauth/token")
            .request(.post, json: authenticationData)
            .onSuccess {
                if let token = $0.jsonDict["access_token"] as? String {
                    self.authenticationToken = "Bearer \(token)"
                }
            }
    }
}
