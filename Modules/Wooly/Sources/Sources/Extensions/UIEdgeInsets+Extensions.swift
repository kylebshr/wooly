import UIKit

extension UIEdgeInsets {
    init(all value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    static let standard = UIEdgeInsets(all: .standard)

    static func * (_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top * rhs, left: lhs.left * rhs, bottom: lhs.bottom * rhs, right: lhs.right * rhs)
    }
}
