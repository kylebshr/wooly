public struct App: Codable {
    var clientName: String
    var redirectUris: String
    var scopes: String
    var website: URL?

    public init(clientName: String, redirectURI: String, website: URL, scopes: String = "read write follow") {
        self.clientName = clientName
        self.redirectUris = redirectURI
        self.scopes = scopes
        self.website = website
    }
}
