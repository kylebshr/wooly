import Foundation

public struct Mention: Codable {
    public let url: URL
    public let username: String
    public let acct: String
    public let id: String
}
