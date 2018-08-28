struct App: Codable {
    var clientName: String
    var redirectUris: String
    var scopes: String
    var website: URL?

    init(clientName: String, redirectURI: String, scopes: String = "read write follow") {
        self.clientName = clientName
        self.redirectUris = redirectURI
        self.scopes = scopes
        self.website = URL(staticString: "https://wooly.social")
    }
}
