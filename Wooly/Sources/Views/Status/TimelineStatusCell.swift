import UIKit
import PINRemoteImage

class TimelineStatusCell: TableViewCell {
    private let avatarView = AvatarControl()
    private let metadataView = StatusMetadataView()
    private let actionView = StatusActionView()
    private let statusLabel = StatusLabel()
    private let cardContainer = ContainerView()

    weak var delegate: StatusViewDelegate? {
        didSet {
            actionView.delegate = delegate
            statusLabel.statusDelegate = delegate
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let contentStack = UIStackView(arrangedSubviews: [metadataView, statusLabel, cardContainer, actionView])
        contentStack.setCustomSpacing(.extraSmallSpacing, after: metadataView)
        contentStack.setCustomSpacing(.standardVerticalEdge, after: cardContainer)
        contentStack.spacing = .standardSpacing
        contentStack.axis = .vertical

        contentView.addSubview(avatarView)
        contentView.addSubview(contentStack)

        avatarView.pinEdges([.left, .top], to: contentView, insets: .standardEdges)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardVerticalEdge)
        avatarView.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standardVerticalEdge, priority: .extraLow)
        avatarView.pinSize(to: 50)

        contentStack.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standardSpacing)
        contentStack.topAnchor.pin(to: avatarView.topAnchor)
        contentStack.pinEdges([.right, .bottom], to: contentView, insets: .standardEdges)
    }

    func display(status: Status) {
        actionView.status = status
        avatarView.url = status.account.avatar
        statusLabel.status = status
        metadataView.display(status: status)

        if let reblog = status.reblog {
            let reblogView = ReblogCardControl()
            reblogView.status = reblog
            cardContainer.child = reblogView
            cardContainer.isHidden = false
        } else {
            cardContainer.child = nil
            cardContainer.isHidden = true
        }

        statusLabel.isHidden = !cardContainer.isHidden
    }
}
