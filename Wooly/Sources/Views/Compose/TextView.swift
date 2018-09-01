import UIKit

class TextView: UIView {
    private let textView = UITextView()
    private let placeholderLabel = Label()

    var font: UIFont? {
        get { return textView.font }
        set {
            textView.font = newValue
            placeholderLabel.font = newValue
        }
    }

    var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(placeholderLabel)
        placeholderLabel.pinEdges([.left, .top, .right], to: self)
        placeholderLabel.isUserInteractionEnabled = false

        addSubview(textView)
        textView.pinEdges(to: self)
        textView.heightAnchor.pin(greaterThan: placeholderLabel.heightAnchor)
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.isScrollEnabled = false
        textView.backgroundColor = nil
        textView.delegate = self

        ThemeController.shared.add(self) { [weak self] _ in
            guard let this = self else { return }
            this.placeholderLabel.textColor = .textSecondary
            this.textView.keyboardAppearance = Appearance.keyboardAppearance
            UIView.transition(with: this.textView, duration: 0, options: .transitionCrossDissolve, animations: {
                this.textView.tintColor = .tint
                this.textView.textColor = .text
            }, completion: nil)
        }
    }

    override var intrinsicContentSize: CGSize {
        return textView.intrinsicContentSize
    }

    override var canBecomeFirstResponder: Bool {
        return textView.canBecomeFirstResponder
    }

    override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }

    override var canResignFirstResponder: Bool {
        return textView.canResignFirstResponder
    }

    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        UIView.animate(withDuration: 0.2) {
            self.invalidateIntrinsicContentSize()
        }
    }
}
