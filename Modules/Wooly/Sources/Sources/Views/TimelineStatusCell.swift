import UIKit
import Mammut
import PINRemoteImage

class TimelineStatusCell: UITableViewCell {
    var status: Status? {
        didSet {
            contentLabel.text = status?.content
            avatarView.pin_setImage(from: status?.account.avatar)
        }
    }

    private let avatarView = UIImageView()
    private let contentLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(avatarView)
        avatarView.pinEdges([.left, .top], to: contentView, insets: .standard)
        avatarView.bottomAnchor.pin(lessThan: contentView.bottomAnchor, constant: -.standard, priority: .defaultHigh)
        avatarView.pinSize(to: 44)

        contentView.addSubview(contentLabel)
        contentLabel.leadingAnchor.pin(to: avatarView.trailingAnchor, constant: .standard)
        contentLabel.pinEdges(.top, to: avatarView)
        contentLabel.pinEdges(.right, to: contentView, insets: .standard)
        contentLabel.bottomAnchor.pin(to: contentView.bottomAnchor, constant: -.standard)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .white

        contentView.backgroundColor = .background
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
