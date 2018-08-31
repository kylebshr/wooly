import UIKit
import PINRemoteImage

class TimelineStatusCell: TableViewCell {

    private let avatarView = AvatarControl()
    private let metadataView = StatusMetadataView()
    private let actionView = StatusActionView()
    private let statusLabel = StatusLabel()

    weak var delegate: StatusViewDelegate? {
        didSet {
            actionView.delegate = delegate
            statusLabel.statusDelegate = delegate
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(actionView)
        contentView.addSubview(avatarView)
        contentView.addSubview(metadataView)
        contentView.addSubview(statusLabel)

        avatarView.pinEdges([.left, .top], to: contentView, insets: .standardEdges)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardVerticalEdge)
        avatarView.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standardVerticalEdge, priority: .extraLow)
        avatarView.pinSize(to: 50)

        metadataView.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standardSpacing)
        metadataView.topAnchor.pin(to: avatarView.topAnchor)
        metadataView.trailingAnchor.pin(to: contentView.trailingAnchor, constant: -.rightHorizontalEdge)

        statusLabel.topAnchor.pin(to: metadataView.bottomAnchor, constant: .extraSmallSpacing)
        statusLabel.pinEdges([.left, .right], to: metadataView)
        statusLabel.bottomAnchor.pin(to: actionView.topAnchor, constant: -.standardVerticalEdge)

        actionView.pinEdges([.left, .right], to: statusLabel)
        actionView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardSpacing)

        statusLabel.numberOfLines = 0
        statusLabel.font = .body
    }

    func display(status: Status) {
        actionView.status = status
        avatarView.url = status.account.avatar
        statusLabel.status = status
        metadataView.display(
            name: status.account.displayName,
            handle: "@\(status.account.username)",
            timestamp: status.createdAt
        )
    }
}
