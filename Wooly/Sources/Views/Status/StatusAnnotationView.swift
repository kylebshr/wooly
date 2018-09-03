import UIKit

class StatusAnnotationView: ContainerView {
    private let imageView = UIImageView()
    private let label = Label()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stack = UIStackView(arrangedSubviews: [imageView, label])
        addSubview(stack)
        stack.pinEdges([.top, .right, .bottom], to: self)
        stack.spacing = .standardSpacing
        stack.alignment = .center

        label.leadingAnchor.pin(to: leadingAnchor)
        label.font = .footnote

        ThemeController.shared.add(self) { [weak self] _ in
            self?.imageView.tintColor = .textSecondary
            self?.label.textColor = .textSecondary
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(annotation: Annotation) {
        imageView.image = annotation.image
        label.text = annotation.text
    }
}

extension StatusAnnotationView {
    struct Annotation {
        let image: UIImage
        let text: String

        static func reblog(_ account: Account) -> Annotation {
            return Annotation(image: #imageLiteral(resourceName: "Reblog Selected Small"), text: "\(account.displayName) Boosted")
        }

        static func reply(_ account: Account) -> Annotation {
            return Annotation(image: #imageLiteral(resourceName: "Reply Selected Small"), text: "\(account.displayName) Replied")
        }
    }
}
