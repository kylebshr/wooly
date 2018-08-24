import Foundation
import Keychain
import Siesta

class MastodonService: Service {
    enum InitializationError: Error {
        case invalidInstanceURL
    }

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

    /// Create a new service
    ///
    /// - Parameter instanceURL: The URL of the Mastodon instance (i.e., `mastodon.social`)
    init(instanceURL: String, refreshToken: String) throws {
        self.refreshToken = refreshToken
        let instanceURL = try URL(string: instanceURL) ?? {
            throw InitializationError.invalidInstanceURL
        }()
        self.authKeychain = Keychain(service: instanceURL.absoluteString, account: "auth-token")

        super.init(baseURL: instanceURL.url?.appendingPathComponent("api/v1"))

        configureHeaders()
        configureTransformers()
    }

    private func configureHeaders() {
        configure("**") {
            $0.headers["Authentication"] = self.authenticationToken
            $0.headers["Content-Type"] = "application/json; charset=utf-8"
        }
    }

    private func configureTransformers() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        configureTransformer("timelines/*") {
            try decoder.decode([Status].self, from: $0.content)
        }
    }
}
