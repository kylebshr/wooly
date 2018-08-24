import UIKit

class InstanceCell: UITableViewCell {
    private let label = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        contentView.addSubview(label)
        label.textColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = layoutMarginsGuide.layoutFrame
    }

    func set(instance: String) {
        label.text = instance
    }
}
