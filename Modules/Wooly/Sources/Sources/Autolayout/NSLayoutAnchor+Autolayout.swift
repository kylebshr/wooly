import UIKit

extension NSLayoutAnchor {
    @objc @discardableResult public func pin(to anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return self.constraint(equalTo: anchor, constant: constant).prioritize(priority).setUp()
    }

    @objc @discardableResult public func pin(greaterThan anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint
    {
        return self.constraint(greaterThanOrEqualTo: anchor, constant: constant).prioritize(priority).setUp()
    }

    @objc @discardableResult public func pin(lessThan anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint
    {
        return self.constraint(lessThanOrEqualTo: anchor, constant: constant).prioritize(priority).setUp()
    }
}
