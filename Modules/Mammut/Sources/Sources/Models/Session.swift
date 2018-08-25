public struct Session: Codable {
    public let instance: Instance
    let client: Client
    let refreshToken: String

    public init(instance: Instance, client: Client, refreshToken: String) {
        self.instance = instance
        self.client = client
        self.refreshToken = refreshToken
    }
}
