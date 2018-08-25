public struct Session: Codable {
    public let instanceURL: String
    let refreshToken: String
    let client: Client

    public init(instanceURL: String, refreshToken: String, client: Client) {
        self.instanceURL = instanceURL
        self.refreshToken = refreshToken
        self.client = client
    }
}
