
public struct Session: Storable, Equatable {
    public let instance: Instance
    public let client: Client
    let refreshToken: String

    public init(instance: Instance, client: Client, refreshToken: String) {
        self.instance = instance
        self.client = client
        self.refreshToken = refreshToken
    }
}
