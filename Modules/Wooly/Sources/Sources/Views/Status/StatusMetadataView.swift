import AsyncDisplayKit
import UIKit

private let formatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.maximumUnitCount = 1
    return formatter
}()

class StatusMetadataNode: ASDisplayNode {
    private let nameLabel = LabelNode()
    private let handleLabel = LabelNode()
    private let timestampLabel = LabelNode()
    private let interpunct = InterpunctNode()

    override func didLoad() {
        super.didLoad()

        addSubnode(nameLabel)
        addSubnode(handleLabel)
        addSubnode(interpunct)
        addSubnode(timestampLabel)

        nameLabel.font = .customCallout
//        nameLabel.set(compressionResistance: .required, for: .vertical)
//        nameLabel.set(compressionResistance: .defaultHigh, for: .horizontal)
//
        handleLabel.font = .customDetail
//        handleLabel.set(compressionResistance: .medium, for: .horizontal)
//
        interpunct.font = .customDetail
//
        timestampLabel.font = .customDetail
//        timestampLabel.set(compressionResistance: .required, for: .horizontal)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.nameLabel.textColor = .text
            self?.handleLabel.textColor = .textSecondary
            self?.interpunct.textColor = .textSecondary
            self?.timestampLabel.textColor = .textSecondary
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        return ASStackLayoutSpec(direction: .horizontal, spacing: .smallSpacing, justifyContent: .start, alignItems: .baselineFirst, children: [nameLabel, handleLabel, interpunct, timestampLabel])

        return ASStackLayoutSpec(direction: .horizontal, spacing: .smallSpacing, justifyContent: .start, alignItems: .baselineFirst, flexWrap: .wrap, alignContent: .start, lineSpacing: 0, children: [nameLabel, handleLabel, interpunct, timestampLabel])
    }

    func display(name: String, handle: String, timestamp: Date) {
        nameLabel.text = name
        handleLabel.text = handle
        timestampLabel.text = formatter.string(from: timestamp, to: Date())
    }
}
