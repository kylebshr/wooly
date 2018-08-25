import UIKit
import Mammut

class TimelineStatusCell: UITableViewCell {
    var status: Status? {
        didSet {
            contentLabel.text = status?.content
        }
    }

    private let contentLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(contentLabel)
        contentLabel.pin(to: contentView)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .white

        contentView.backgroundColor = .background
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
