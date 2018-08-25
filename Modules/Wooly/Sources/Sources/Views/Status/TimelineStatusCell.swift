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
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardSpacing, priority: .almostRequired)
        avatarView.pinSize(to: 50)

        contentLabel.numberOfLines = 0
        contentLabel.textColor = .text
        contentLabel.font = .customBody

        let contentStack = UIStackView()
        contentStack.distribution = .fill
        contentStack.spacing = .extraSmallSpacing
        contentStack.axis = .vertical
        contentStack.addArrangedSubview(metadataView)
        contentStack.addArrangedSubview(contentLabel)

        contentView.addSubview(contentStack)
        contentStack.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standardSpacing)
        contentStack.pinEdges(.top, to: avatarView)
        contentStack.pinEdges(.right, to: contentView, insets: .standardSpacing)
        contentStack.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardSpacing, priority: .almostRequired)
        contentStack.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standardSpacing, priority: .extraLow)
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
