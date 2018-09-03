import UIKit

private let formatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.maximumUnitCount = 1
    return formatter
}()

class StatusMetadataView: ContainerView {
    private let mainStack = StackView()
    private let detailStack = StackView()
    private let nameLabel = Label()
    private let handleLabel = Label()
    private let timestampLabel = Label()
    private let interpunctView = InterpunctView()

    var status: Status? {
        didSet { if let status = status { display(status: status) } }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.updateTimestamp()
        }

        addSubview(mainStack)
        mainStack.pinEdges([.left, .top, .bottom], to: self, insets: .init(top: 2, left: 0, bottom: 0, right: 0))
        mainStack.trailingAnchor.pin(lessThan: self.trailingAnchor)
        mainStack.spacing = .smallSpacing
        mainStack.addArrangedSubviews([nameLabel, detailStack])

        detailStack.spacing = .smallSpacing
        detailStack.alignment = .firstBaseline
        detailStack.addArrangedSubviews([handleLabel, interpunctView, timestampLabel])

        nameLabel.font = .callout
        nameLabel.capHeightRelativeLayout = true
        nameLabel.set(compressionResistance: .required, for: .vertical)
        nameLabel.set(compressionResistance: .defaultHigh, for: .horizontal)

        handleLabel.font = .detail
        handleLabel.capHeightRelativeLayout = true
        handleLabel.set(compressionResistance: .medium, for: .horizontal)

        interpunctView.font = .detail
        interpunctView.capHeightRelativeLayout = true

        timestampLabel.font = .detail
        timestampLabel.capHeightRelativeLayout = true
        timestampLabel.set(compressionResistance: .required, for: .horizontal)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.nameLabel.textColor = .text
            self?.handleLabel.textColor = .textSecondary
            self?.interpunctView.textColor = .textSecondary
            self?.timestampLabel.textColor = .textSecondary
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func display(status: Status) {
        nameLabel.text = status.account.displayName
        handleLabel.text = "@\(status.account.username)"
        updateTimestamp()
    }

    func updateTimestamp() {
        if let status = status {
            timestampLabel.text = formatter.string(from: status.createdAt, to: Date())
        }
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
