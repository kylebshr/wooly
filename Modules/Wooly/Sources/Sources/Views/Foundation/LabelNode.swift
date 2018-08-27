import AsyncDisplayKit

class LabelNode: ASTextNode {
    var textColor: UIColor = .black {
        didSet { update() }
    }

    var font: UIFont = .customBody {
        didSet { update() }
    }

    var text: String? {
        didSet { update() }
    }

    private func update() {
        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: textColor, .font: font]
        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
