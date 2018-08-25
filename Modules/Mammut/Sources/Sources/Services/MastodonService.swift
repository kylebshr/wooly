import Foundation
import Keychain
import Siesta

public class MastodonService: Service {
    enum InitializationError: Error {
        case invalidInstanceURL
    }

    private let session: Session
    private let authKeychain: Keychain<StorableBox<String>>

    private var authenticationToken: String? {
        get {
            return authKeychain.value?.value
        }
        set {
            if let value = newValue {
                authKeychain.value = StorableBox(value)
            }
            invalidateConfiguration()
            wipeResources()
        }
    }

    private var authenticationData: [String: Any] {
        return [
            "client_id": session.client.clientId,
            "client_secret": session.client.clientSecret,
            "code": session.refreshToken,
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
        self.session = session
        self.authKeychain = Keychain(service: session.instance.name, account: "auth-token")

        super.init(baseURL: session.instance.url.appendingPathComponent("api/v1"), standardTransformers: [.text, .image])

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
        decoder.dateDecodingStrategy = .formatted(.mastodonFormatter)

        configure(whenURLMatches: { $0.absoluteString.contains("oauth/token") }) {
            $0.pipeline[.model].add(JSONResponseTransformer())
        }

        configureTransformer("timelines/*") {
            try decoder.decode([Status].self, from: $0.content)
        }
    }

    private func createAuthToken() -> Request {
        return resource(baseURL: session.instance.url, path: "oauth/token")
            .request(.post, json: authenticationData)
            .onSuccess {
                if let token = $0.jsonDict["access_token"] as? String {
                    self.authenticationToken = "Bearer \(token)"
                }
            }
    }
}