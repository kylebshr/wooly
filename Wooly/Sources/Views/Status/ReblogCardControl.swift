import UIKit

class ReblogCardControl: Control {
    private let metadataView = StatusMetadataView()
    private let statusLabel = StatusLabel()

    override var isHighlighted: Bool {
        didSet { backgroundColor = isHighlighted ? .highlight : nil }
    }

    var status: Status? {
        didSet { if let status = status { self.display(status: status) } }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let mainStack = UIStackView(arrangedSubviews: [metadataView, statusLabel])
        addSubview(mainStack)
        mainStack.pinEdges(to: self, insets: .standardEdges)
        mainStack.isUserInteractionEnabled = false
        mainStack.spacing = .extraSmallSpacing
        mainStack.axis = .vertical

        layer.cornerRadius = .standardSpacing
        layer.borderWidth = .pixel

        ThemeController.shared.add(self) { [weak self] _ in
            self?.layer.borderColor = UIColor.separator.cgColor
        }
    }

    private func display(status: Status) {
        metadataView.display(status: status)
        statusLabel.status = status
    }
}
