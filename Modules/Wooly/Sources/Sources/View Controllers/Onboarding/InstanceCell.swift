import UIKit
import Mammut

class InstanceCell: TableViewCell {
    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator

        contentView.addSubview(label)
        label.textColor = .text
        label.font = .preferredFont(forTextStyle: .body)
        label.pinEdges(to: contentView, insets: .standardEdges)
    }

    func set(instance: Instance) {
        label.text = instance.name
    }
}
