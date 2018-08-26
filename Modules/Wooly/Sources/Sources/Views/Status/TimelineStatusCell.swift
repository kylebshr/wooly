import UIKit
import Mammut
import PINRemoteImage

class TimelineStatusCell: TableViewCell {

    private let avatarView = CircularImageView()
    private let metadataView = StatusMetadataView()
    private let contentLabel = Label()


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarView)
        avatarView.pinEdges([.left, .top], to: contentView, insets: .standardEdges)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardVerticalEdge)
        avatarView.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standardVerticalEdge, priority: .extraLow)
        avatarView.pinSize(to: 50)

        contentView.addSubview(metadataView)
        metadataView.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standardSpacing)
        metadataView.topAnchor.pin(to: avatarView.topAnchor)
        metadataView.trailingAnchor.pin(to: contentView.trailingAnchor, constant: -.rightHorizontalEdge)

        contentView.addSubview(contentLabel)
        contentLabel.topAnchor.pin(to: metadataView.bottomAnchor, constant: .extraSmallSpacing)
        contentLabel.pinEdges([.left, .right], to: metadataView)
        contentLabel.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardVerticalEdge)

        contentLabel.numberOfLines = 0
        contentLabel.font = .customBody

        ThemeController.shared.add(self) { [weak self] _ in
            self?.contentLabel.textColor = .text
        }
    }

    func display(status: Status) {
        avatarView.pin_setImage(from: status.account.avatar)
        contentLabel.text = status.strippedContent
        metadataView.display(
            name: status.account.displayName,
            handle: "@\(status.account.username)",
            timestamp: status.createdAt
        )
    }
}
