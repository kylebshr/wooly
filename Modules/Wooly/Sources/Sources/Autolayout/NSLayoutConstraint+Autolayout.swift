import UIKit

extension NSLayoutConstraint {
    @discardableResult public func activate() -> Self {
        self.isActive = true
        return self
    }

    @discardableResult public func deactivate() -> Self {
        self.isActive = false
        return self
    }

    @discardableResult public func prioritize(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }

    func setUp() -> NSLayoutConstraint {
        (self.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        self.activate()
        return self
    }
}
