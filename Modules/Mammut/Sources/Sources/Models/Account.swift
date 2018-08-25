import Foundation

public struct Account: Codable {
    public let id: String
    public let username: String
    public let acct: String
    public let displayName: String
    public let note: String
    public let url: String
    public let avatar: URL
    public let avatarStatic: String
    public let header: String
    public let headerStatic: String
    public let locked: Bool
    public let createdAt: Date
    public let followersCount: Int
    public let followingCount: Int
    public let statusesCount: Int
}
