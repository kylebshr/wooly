import UIKit

class TextField: UITextField {
    override var placeholder: String? {
        get { return super.placeholder }
        set { updatePlaceholder(with: newValue) }
    }

    private var placeholderColor: UIColor? {
        didSet { updatePlaceholder(with: placeholder) }
    }

    private let borderLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        font = .title3
        adjustsFontForContentSizeCategory = true
        clearButtonMode = .always

        borderLayer.lineWidth = 1
        borderLayer.fillColor = nil
        layer.addSublayer(borderLayer)

        ThemeController.shared.add(self) { [weak self] _ in
            guard let this = self else { return }
            this.borderLayer.strokeColor = UIColor.separator.cgColor
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

    override func layoutSubviews() {
        super.layoutSubviews()

        let radii = CGSize(width: .mediumSpacing, height: .mediumSpacing)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: radii).cgPath

        borderLayer.path = path
        maskLayer.path = path
        layer.mask = maskLayer
    }
}
