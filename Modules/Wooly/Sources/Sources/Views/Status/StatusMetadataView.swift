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
        nameLabel.textColor = .text
        nameLabel.set(hugging: .defaultHigh, for: .horizontal)

        handleLabel.font = .customDetail
        handleLabel.textColor = .textSecondary
        handleLabel.set(hugging: .medium, for: .horizontal)

        interpunctView.font = .customDetail
        interpunctView.textColor = .textSecondary

        timestampLabel.font = .customDetail
        timestampLabel.textColor = .textSecondary
        timestampLabel.set(hugging: .required, for: .horizontal)
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
