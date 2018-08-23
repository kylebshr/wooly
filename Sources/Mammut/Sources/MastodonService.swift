import Siesta

class MastodonService: Service {

    private let refreshToken: String

    private var authenticationToken: String? {
        didSet {
            invalidateConfiguration()
            wipeResources()
        }
    }

    /// Create a new service
    ///
    /// - Parameter instanceURL: The URL of the Mastodon instance (i.e., `mastodon.social`)
    init(instanceURL: URLConvertible, refreshToken: String) {
        self.refreshToken = refreshToken


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
