import UIKit

class TableViewCell: UITableViewCell {
    private let selectedView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.addSubview(selectedView)
        selectedView.pinEdges(to: self)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.backgroundColor = .background
            self?.contentView.backgroundColor = .background
            self?.selectedView.backgroundColor = .highlight
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateHighlight(animated: animated)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setSelected(highlighted, animated: animated)
        updateHighlight(animated: animated)
    }

    private func updateHighlight(animated: Bool) {
        let shouldHighlight = self.isSelected || self.isHighlighted
        let animations = { self.selectedView.alpha = shouldHighlight ? 1 : 0 }
        guard animated else { return animations() }
        UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut, animations: animations).startAnimation()
    }
}
