struct App: Codable {
    var clientName: String
    var redirectUris: String
    var scopes: String
    var website: URL?

    init(clientName: String, redirectURI: String = "urn:ietf:wg:oauth:2.0:oob",
         scopes: String = "read write follow", website: URL? = nil) {
        self.clientName = clientName
        self.redirectUris = redirectURI
        self.scopes = scopes
        self.website = website
    }
}
