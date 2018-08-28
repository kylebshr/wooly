import UIKit
import Mammut
import PINRemoteImage
import ActiveLabel

class TimelineStatusCell: TableViewCell {

    private let avatarView = AvatarControl()
    private let metadataView = StatusMetadataView()
    private let actionView = StatusActionView()
    private let contentLabel = StatusContentLabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(actionView)
        contentView.addSubview(avatarView)
        contentView.addSubview(metadataView)
        contentView.addSubview(contentLabel)

        avatarView.pinEdges([.left, .top], to: contentView, insets: .standardEdges)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardVerticalEdge)
        avatarView.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standardVerticalEdge, priority: .extraLow)
        avatarView.pinSize(to: 50)

        metadataView.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standardSpacing)
        metadataView.topAnchor.pin(to: avatarView.topAnchor)
        metadataView.trailingAnchor.pin(to: contentView.trailingAnchor, constant: -.rightHorizontalEdge)

        contentLabel.topAnchor.pin(to: metadataView.bottomAnchor, constant: .extraSmallSpacing)
        contentLabel.pinEdges([.left, .right], to: metadataView)
        contentLabel.bottomAnchor.pin(to: actionView.topAnchor, constant: -.standardSpacing)

        actionView.pinEdges([.left, .right], to: contentLabel)
        actionView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardVerticalEdge)

        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.font = .body

        ThemeController.shared.add(self) { [weak self] _ in
            self?.contentLabel.textColor = .text
        }
    }

    func display(status: Status) {
        actionView.display(boosts: status.reblogsCount, favorites: status.favouritesCount)
        avatarView.url = status.account.avatar
        contentLabel.text = status.strippedContent
        metadataView.display(
            name: status.account.displayName,
            handle: "@\(status.account.username)",
            timestamp: status.createdAt
        )
    }
}

extension TimelineStatusCell: ActiveLabelDelegate {
    func didSelect(_ text: String, type: ActiveType) {
        print("didSelect: \(text) type: \(type)")
    }
}
