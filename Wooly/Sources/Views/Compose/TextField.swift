import UIKit

class TextField: UITextField {
    override var placeholder: String? {
        get { return super.placeholder }
        set { updatePlaceholder(with: newValue) }
    }

    private var placeholderColor: UIColor? {
        didSet { updatePlaceholder(with: placeholder) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        font = .title3
        adjustsFontForContentSizeCategory = true
        clearButtonMode = .always

        layer.cornerRadius = .mediumSpacing
        layer.borderWidth = .pixel

        ThemeController.shared.add(self) { [weak self] _ in
            guard let this = self else { return }
            this.layer.borderColor = UIColor.separator.cgColor
            this.backgroundColor = .backgroundSecondary
            this.tintColor = .tint
            UIView.transition(with: this, duration: 0, options: .transitionCrossDissolve, animations: {
                this.textColor = .text
                this.keyboardAppearance = Appearance.keyboardAppearance
                this.placeholderColor = .textSecondary
            }, completion: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return editingRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: .standardEdges)
    }

    private func updatePlaceholder(with placeholder: String?) {
        guard let placeholderColor = placeholderColor else {
            super.placeholder = placeholder
            return
        }

        guard let placeholder = placeholder else {
            return
        }

        super.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [
            .foregroundColor: placeholderColor
        ])
    }
}
