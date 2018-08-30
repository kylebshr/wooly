import UIKit

class AvatarControl: Control {

    private let highlightView = UIView()
    private let imageView = UIImageView()

    var url: URL? {
        didSet { imageView.pin_setImage(from: url) }
    }

    override var isHighlighted: Bool {
        didSet { highlightView.isHidden = !isHighlighted }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.masksToBounds = true

        addSubview(imageView)
        addSubview(highlightView)

        imageView.pinEdges(to: self)
        imageView.layer.masksToBounds = true

        highlightView.pinEdges(to: self)
        highlightView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        highlightView.isHidden = true

        ThemeController.shared.add(self) { [weak self] _ in
            self?.backgroundColor = .backgroundSecondary
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.layer.cornerRadius = imageView.bounds.height / 2
        layer.cornerRadius = bounds.height / 2
    }
}
