import UIKit

class StatusMetadataView: UIView {
    private let nameLabel = Label()
    private let handleLabel = Label()
    private let timestampLabel = Label()
    private let interpunctView = InterpunctView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let orderedViews = [nameLabel, handleLabel, interpunctView, timestampLabel]
        orderedViews.forEach { addSubview($0) }
        orderedViews.align(anchors: \.lastBaselineAnchor)
        orderedViews.pin(anchors: \.trailingAnchor, to: \.leadingAnchor, spacing: .smallSpacing)
        nameLabel.pinEdges([.left, .top, .bottom], to: self)
        timestampLabel.trailingAnchor.pin(lessThan: trailingAnchor)

        nameLabel.font = .customCallout
        nameLabel.set(compressionResistance: .required, for: .vertical)
        nameLabel.set(compressionResistance: .defaultHigh, for: .horizontal)

        handleLabel.font = .customDetail
        handleLabel.set(compressionResistance: .medium, for: .horizontal)

        interpunctView.font = .customDetail

        timestampLabel.font = .customDetail
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

    func display(name: String, handle: String, timestamp: Date) {
        nameLabel.text = name
        handleLabel.text = handle
        timestampLabel.text = "5h"
    }
}
