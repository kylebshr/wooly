import UIKit

class StatusActionButton: Control {
    var selectedColor: UIColor = .blue {
        didSet { updateColor() }
    }

    var title: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    private let image: UIImage
    private let selectedImage: UIImage
    private let shouldPlayHaptics: Bool

    private let haptics = UIImpactFeedbackGenerator()
    private let imageView = UIImageView()
    private let label = Label()

    override var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }
            imageView.image = isSelected ? selectedImage : image
            updateColor()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1
        }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        updateColor()
    }

    init(image: UIImage, selectedImage: UIImage? = nil, haptics: Bool = false) {
        self.image = image
        self.selectedImage = selectedImage ?? image
        self.shouldPlayHaptics = haptics

        super.init(frame: .zero)

        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)

        addSubview(label)
        addSubview(imageView)

        label.font = .footnote
        label.pinEdges([.top, .right, .bottom], to: self)
        label.leadingAnchor.pin(to: imageView.trailingAnchor, constant: .extraSmallSpacing)

        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.setHuggingAndCompression(to: .required)
        imageView.image = self.image
        imageView.pinEdges([.top, .left, .bottom], to: self)

        updateColor()
    }

    @objc private func touchUpInside() {
        isSelected = !isSelected

        if isSelected && shouldPlayHaptics { animateBounce() }
        if shouldPlayHaptics { haptics.impactOccurred() }
        updateColor()

        sendActions(for: .primaryActionTriggered)
        sendActions(for: .valueChanged)
    }

    func animateBounce() {
        imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 7, options: [], animations: {
            self.imageView.transform = .identity
        }, completion: nil)
    }

    private func updateColor() {
        let color: UIColor
        switch tintAdjustmentMode {
        case .dimmed: color = tintColor
        default: color = isSelected ? selectedColor : tintColor
        }

        imageView.tintColor = color
        label.textColor = color
    }
}
