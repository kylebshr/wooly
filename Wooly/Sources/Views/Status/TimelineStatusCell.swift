import UIKit
import PINRemoteImage

class TimelineStatusCell: TableViewCell {
    private let annotationView = StatusAnnotationView()
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

        let contentStack = StackView(arrangedSubviews: [annotationView, metadataView, statusLabel, actionView])
        contentStack.setCustomSpacing(.smallSpacing, after: annotationView)
        contentStack.setCustomSpacing(.extraSmallSpacing, after: metadataView)
        contentStack.setCustomSpacing(.standardSpacing, after: statusLabel)
        contentStack.add(spacing: .mediumSpacing, after: actionView)
        contentStack.axis = .vertical

        contentView.addSubview(avatarView)
        contentView.addSubview(contentStack)

        avatarView.pinEdges(.left, to: contentView, insets: .standardEdges)
        avatarView.topAnchor.pin(to: metadataView.topAnchor)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.mediumSpacing)
        avatarView.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.mediumSpacing, priority: .extraLow)
        avatarView.pinSize(to: 50)

        contentStack.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standardSpacing)
        contentStack.pinEdges([.top, .right], to: contentView, insets: .standardEdges)
        contentStack.pinEdges(.bottom, to: contentView)
    }

    func display(status: Status) {
        let mainStatus = status.reblog ?? status

        actionView.status = mainStatus
        avatarView.url = mainStatus.account.avatar
        statusLabel.status = mainStatus
        metadataView.status = mainStatus

        if status.reblog != nil {
            annotationView.display(annotation: .reblog(status.account))
            annotationView.isHidden = false
        } else if status.inReplyToAccountId != nil {
            annotationView.display(annotation: .reply(status.account))
            annotationView.isHidden = false
        } else {
            annotationView.isHidden = true
        }
    }
}
