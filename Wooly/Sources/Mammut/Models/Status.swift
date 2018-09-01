import Foundation

final public class Status: Codable {
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
    public let mentions: [Mention]
//    public let tags: [Tag]
//    public let application: Application?
    public let language: String?
    public let reblog: Status?
    public let pinned: Bool?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        uri = try values.decode(String.self, forKey: .uri)
        url = try values.decodeIfPresent(URL.self, forKey: .url)
        account = try values.decode(Account.self, forKey: .account)
        inReplyToId = try values.decodeIfPresent(String.self, forKey: .inReplyToId)
        inReplyToAccountId = try values.decodeIfPresent(String.self, forKey: .inReplyToAccountId)
        let rawContent = try values.decode(String.self, forKey: .content)
        content = rawContent.removingHTML()
        createdAt = try values.decode(Date.self, forKey: .createdAt)
//        emojis = try values.decode([Emoji].self, forKey: .emojis)
        repliesCount = try values.decode(Int.self, forKey: .repliesCount)
        reblogsCount = try values.decode(Int.self, forKey: .reblogsCount)
        favouritesCount = try values.decode(Int.self, forKey: .favouritesCount)
        reblogged = try values.decodeIfPresent(Bool.self, forKey: .reblogged)
        favourited = try values.decodeIfPresent(Bool.self, forKey: .favourited)
        sensitive = try values.decodeIfPresent(Bool.self, forKey: .sensitive)
        spoilerText = try values.decode(String.self, forKey: .spoilerText)
//        visibility = try values.decode(Visibility.self, forKey: .visibility)
//        mediaAttachments = try values.decode([Attachment].self, forKey: .mediaAttachments)
        mentions = try values.decode([Mention].self, forKey: .mentions)
//        tags = try values.decode([Tag].self, forKey: .tags)
//        application = try values.decode(Application?.self, forKey: .application)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        reblog = try values.decodeIfPresent(Status.self, forKey: .reblog)
        pinned = try values.decodeIfPresent(Bool.self, forKey: .pinned)
    }
}
