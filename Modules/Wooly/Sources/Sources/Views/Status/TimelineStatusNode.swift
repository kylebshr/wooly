import AsyncDisplayKit
import PINRemoteImage
import Mammut

class TimelineStatusNode: ASCellNode {

    private let avatarNode = ASNetworkImageNode()
    private let metadataNode = StatusMetadataNode()
    private let contentLabel = LabelNode()

    override func didLoad() {
        super.didLoad()

        addSubnode(avatarNode)
        addSubnode(metadataNode)
        addSubnode(contentLabel)

        let avatarSize = CGSize(width: 50, height: 50)

        contentLabel.maximumNumberOfLines = 0
        contentLabel.font = .customBody

        avatarNode.style.width = ASDimensionMake(50)
        avatarNode.style.height = ASDimensionMake(50)

        avatarNode.imageModificationBlock = { image in
            return image.makeCircularImage(size: avatarSize)
        }

        ThemeController.shared.add(self) { [weak self] _ in
            self?.contentLabel.textColor = .text
            self?.backgroundColor = .background
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentSpec = ASStackLayoutSpec(direction: .vertical, spacing: .extraSmallSpacing, justifyContent: .start, alignItems: .start, children: [metadataNode, contentLabel])
        contentSpec.style.flexShrink = 1
        contentSpec.style.flexGrow = 1

        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: .standardSpacing, justifyContent: .start, alignItems: .start, children: [avatarNode, contentSpec])

        return ASInsetLayoutSpec(insets: .standardEdges, child: mainStack)
    }

    func display(status: Status) {
        contentLabel.text = status.strippedContent!
        avatarNode.url = status.account.avatar
        metadataNode.display(
            name: status.account.displayName,
            handle: "@\(status.account.username)",
            timestamp: status.createdAt
        )
    }
}

extension UIImage {

    func makeCircularImage(size: CGSize) -> UIImage {
        // make a CGRect with the image's size
        let circleRect = CGRect(origin: .zero, size: size)

        // begin the image context since we're not in a drawRect:
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)

        // create a UIBezierPath circle
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width * 0.5)

        // clip to the circle
        circle.addClip()

        UIColor.white.set()
        circle.fill()

        // draw the image in the circleRect *AFTER* the context is clipped
        self.draw(in: circleRect)

        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()

        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext()

        return roundedImage ?? self
    }
}
