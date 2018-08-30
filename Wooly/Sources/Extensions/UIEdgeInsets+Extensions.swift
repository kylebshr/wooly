import UIKit

extension UIEdgeInsets {
    init(all value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    static let standardEdges = UIEdgeInsets(
        top: .standardVerticalEdge,
        left: .leftHorizontalEdge,
        bottom: .standardVerticalEdge,
        right: .rightHorizontalEdge
    )

    static let standardSpacing = UIEdgeInsets(all: .standardSpacing)
}
