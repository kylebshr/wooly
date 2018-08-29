import UIKit
import Mammut
import PINRemoteImage

class TimelineStatusCell: TableViewCell {

    private let avatarView = AvatarControl()
    private let metadataView = StatusMetadataView()
    private let actionView = StatusActionView()
    private let contentLabel = Label()

    weak var delegate: StatusViewDelegate? {
        didSet { actionView.delegate = delegate }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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

        contentLabel.isUserInteractionEnabled = false
        contentLabel.numberOfLines = 0
        contentLabel.font = .body

        ThemeController.shared.add(self) { [weak self] _ in
            guard let this = self else { return }
            UIView.transition(with: this.contentLabel, duration: 0, options: [.transitionCrossDissolve], animations: {
                this.contentLabel.textColor = .text
            }, completion: nil)
        }
    }

    func display(status: Status) {
        actionView.status = status
        avatarView.url = status.account.avatar
        contentLabel.text = status.strippedContent
        metadataView.display(
            name: status.account.displayName,
            handle: "@\(status.account.username)",
            timestamp: status.createdAt
        )
    }
}
