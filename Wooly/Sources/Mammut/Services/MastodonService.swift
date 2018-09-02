import Foundation
import Siesta

public class MastodonService: Service {
    enum InitializationError: Error {
        case invalidInstanceURL
    }

    private let session: Session
    private let authKeychain: Keychain<StorableBox<String>>
    private let invalidateSession: () -> Void

    private var authenticationToken: String? {
        get {
            return authKeychain.value?.value
        }
        set {
            if let value = newValue {
                authKeychain.value = StorableBox(value)
            } else if newValue != authenticationToken {
                wipeResources()
            }

            invalidateConfiguration()
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

    var currentUser: Resource {
        return resource("accounts/verify_credentials")
    }

    /// Create a new service
    ///
    /// - Parameters:
    ///   - session:            The current user's session
    ///   - tokenStorage:       A keychain for storing the authentication token
    ///   - invalidateSession:  Called if we can't refresh our authentication token with the given session
    public init(session: Session, tokenStorage: Keychain<StorableBox<String>>, invalidateSession: @escaping () -> Void) {
        self.session = session
        self.authKeychain = tokenStorage
        self.invalidateSession = invalidateSession

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

        configureTransformer("accounts/*") {
            try decoder.decode(Account.self, from: $0.content)
        }
    }

    private func createAuthToken() -> Request {
        return resource(baseURL: session.instance.url, path: "oauth/token")
            .request(.post, json: authenticationData)
            .onSuccess {
                print("--- Got auth token!")
                if let token = $0.jsonDict["access_token"] as? String {
                    self.authenticationToken = "Bearer \(token)"
                }
            } .onFailure { [weak self] error in
                print("--- Authentication token failed: \(error)")
                self?.invalidateSession()
            }
    }

    func post(status: String, replyingTo inReplyToID: String?) -> Request {
        return resource("statuses").request(.post, json: [
            "status": status,
            "in_reply_to_id": inReplyToID
        ])
    }

    func statusResource(with ID: String) -> Resource {
        return resource("statuses")
            .child(ID)
    }

    func setFavorite(_ isFavorite: Bool, status: Status) {
        _ = statusResource(with: status.id)
            .child(isFavorite ? "favourite" : "unfavourite")
            .request(.post)
    }

    func setReblog(_ isReblog: Bool, status: Status) {
        _ = statusResource(with: status.id)
            .child(isReblog ? "reblog" : "unreblog")
            .request(.post)
    }
}
