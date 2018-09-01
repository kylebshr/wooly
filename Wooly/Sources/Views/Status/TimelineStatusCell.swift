import UIKit
import PINRemoteImage

class TimelineStatusCell: TableViewCell {
    private let annotationView = StatusAnnotationView()
    private let avatarView = AvatarControl()
    private let metadataView = StatusMetadataView()
    private let actionView = StatusActionView()
    private let statusLabel = StatusLabel()
    private let mediaContainer = ContainerView()

    weak var delegate: StatusViewDelegate? {
        didSet {
            actionView.delegate = delegate
            statusLabel.statusDelegate = delegate
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let contentStack = UIStackView(arrangedSubviews: [annotationView, metadataView, statusLabel, mediaContainer, actionView])
        contentStack.setCustomSpacing(.extraSmallSpacing, after: metadataView)
        contentStack.setCustomSpacing(.standardVerticalEdge, after: mediaContainer)
        contentStack.spacing = .standardSpacing
        contentStack.axis = .vertical

        contentView.addSubview(avatarView)
        contentView.addSubview(contentStack)

        avatarView.pinEdges(.left, to: contentView, insets: .standardEdges)
        avatarView.topAnchor.pin(to: metadataView.topAnchor)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standardVerticalEdge)
        avatarView.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standardVerticalEdge, priority: .extraLow)
        avatarView.pinSize(to: 50)

        contentStack.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standardSpacing)
        contentStack.pinEdges([.top, .right, .bottom], to: contentView, insets: .standardEdges)
    }

    func display(status: Status) {
        let mainStatus = status.reblog ?? status

        actionView.status = mainStatus
        avatarView.url = mainStatus.account.avatar
        statusLabel.status = mainStatus
        metadataView.display(status: mainStatus)

        if status.reblog != nil {
            annotationView.display(annotation: .reblog(status.account))
            annotationView.isHidden = false
        } else {
            annotationView.isHidden = true
        }

        mediaContainer.isHidden = true
    }
}
