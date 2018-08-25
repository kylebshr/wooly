import UIKit
import Mammut
import PINRemoteImage

class TimelineStatusCell: UITableViewCell {
    var status: Status? {
        didSet {
            avatarView.pin_setImage(from: status?.account.avatar)
            contentLabel.text = status?.strippedContent
            nameLabel.text = status?.account.displayName
            handleLabel.text = "@\(status?.account.username ?? "")"
        }
    }

    private let avatarView = CircularImageView()
    private let contentLabel = UILabel()
    private let nameLabel = UILabel()
    private let handleLabel = UILabel()
    private let timestampLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarView)
        avatarView.pinEdges([.left, .top], to: contentView, insets: .standard)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standard, priority: .defaultHigh)
        avatarView.pinSize(to: 44)

        contentLabel.numberOfLines = 0
        contentLabel.textColor = .text
        contentLabel.font = .preferredFont(forTextStyle: .body)

        nameLabel.textColor = .text
        nameLabel.font = .preferredFont(forTextStyle: .footnote)

        handleLabel.textColor = .textSecondary
        handleLabel.font = .preferredFont(forTextStyle: .footnote)

        let topLabelStack = UIStackView()
        topLabelStack.alignment = .firstBaseline
        topLabelStack.spacing = .standard / 2
        topLabelStack.addArrangedSubview(nameLabel)
        topLabelStack.addArrangedSubview(handleLabel)
        topLabelStack.addArrangedSubview(timestampLabel)

        let contentStack = UIStackView()
        contentStack.alignment = .leading
        topLabelStack.spacing = .standard / 2
        contentStack.axis = .vertical
        contentStack.addArrangedSubview(topLabelStack)
        contentStack.addArrangedSubview(contentLabel)

        contentView.addSubview(contentStack)
        contentStack.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standard)
        contentStack.pinEdges(.top, to: avatarView)
        contentStack.pinEdges(.right, to: contentView, insets: .standard)
        contentStack.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standard, priority: .defaultHigh)
        contentStack.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standard, priority: UILayoutPriority(10))

        contentView.backgroundColor = .background
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
