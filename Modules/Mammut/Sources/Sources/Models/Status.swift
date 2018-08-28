import Foundation

public struct Status: Codable {
    public let id: String
    public let uri: String
    public let url: URL?
    public let account: Account
    public let inReplyToId: String?
    public let inReplyToAccountId: String?
    public let content: String
    public let createdAt: Date
//    public let emojis: [Emoji]
    public let repliesCount: Int
    public let reblogsCount: Int
    public let favouritesCount: Int
    public let reblogged: Bool?
    public let favourited: Bool?
    public let sensitive: Bool?
    public let spoilerText: String
//    public let visibility: Visibility
//    public let mediaAttachments: [Attachment]
//    public let mentions: [Mention]
//    public let tags: [Tag]
//    public let application: Application?
    public let language: String?
//    public let reblog: Status?
    public let pinned: Bool?
}
