import UIKit

class StatusMetadataView: UIStackView {
    private let nameLabel = Label()
    private let handleLabel = Label()
    private let timestampLabel = Label()
    private let interpunctView = InterpunctView()
    private let paddingView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addArrangedSubview(nameLabel)
        addArrangedSubview(handleLabel)
        addArrangedSubview(interpunctView)
        addArrangedSubview(timestampLabel)
        addArrangedSubview(paddingView)

        spacing = .smallSpacing
        alignment = .lastBaseline
        paddingView.backgroundColor = .clear

        nameLabel.font = .customCallout
        nameLabel.set(hugging: .defaultHigh, for: .horizontal)

        handleLabel.font = .customDetail
        handleLabel.set(hugging: .medium, for: .horizontal)

        interpunctView.font = .customDetail

        timestampLabel.font = .customDetail
        timestampLabel.set(hugging: .required, for: .horizontal)

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

    func display(name: String, handle: String, timestamp: Date) {
        nameLabel.text = name
        handleLabel.text = handle
        timestampLabel.text = "5h"
    }
}
