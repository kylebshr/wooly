import UIKit

private let formatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.maximumUnitCount = 1
    return formatter
}()

class StatusMetadataView: UIView {
    private let mainStack = StackView()
    private let detailStack = StackView()
    private let nameLabel = Label()
    private let handleLabel = Label()
    private let timestampLabel = Label()
    private let interpunctView = InterpunctView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(mainStack)
        mainStack.pinEdges([.left, .top, .bottom], to: self)
        mainStack.trailingAnchor.pin(lessThan: self.trailingAnchor)
        mainStack.spacing = .smallSpacing
        mainStack.addArrangedSubviews([nameLabel, detailStack])

        detailStack.spacing = .smallSpacing
        detailStack.alignment = .firstBaseline
        detailStack.addArrangedSubviews([handleLabel, interpunctView, timestampLabel])

        nameLabel.font = .callout
        nameLabel.set(compressionResistance: .required, for: .vertical)
        nameLabel.set(compressionResistance: .defaultHigh, for: .horizontal)

        handleLabel.font = .detail
        handleLabel.set(compressionResistance: .medium, for: .horizontal)

        interpunctView.font = .detail

        timestampLabel.font = .detail
        timestampLabel.set(compressionResistance: .required, for: .horizontal)

        ThemeController.shared.add(self) { [weak self] _ in
            guard let this = self else { return }

            UIView.transition(with: this, duration: 0, options: [.transitionCrossDissolve], animations: {
                this.nameLabel.textColor = .text
                this.handleLabel.textColor = .textSecondary
                this.interpunctView.textColor = .textSecondary
                this.timestampLabel.textColor = .textSecondary
            }, completion: nil)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(name: String, handle: String, timestamp: Date) {
        nameLabel.text = name
        handleLabel.text = handle
        timestampLabel.text = formatter.string(from: timestamp, to: Date())
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.preferredContentSizeCategory > .extraExtraLarge {
            mainStack.alignment = .leading
            mainStack.axis = .vertical
        } else {
            mainStack.alignment = .firstBaseline
            mainStack.axis = .horizontal
        }
    }
}
