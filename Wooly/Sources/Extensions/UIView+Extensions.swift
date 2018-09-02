import UIKit

private let minimumDimension: CGFloat = 44

extension UIView {
    func setHuggingAndCompression(to priority: UILayoutPriority) {
        set(contentHugging: priority, for: .horizontal)
        set(contentHugging: priority, for: .vertical)
        set(compressionResistance: priority, for: .horizontal)
        set(compressionResistance: priority, for: .vertical)
    }


    func setHuggingAndCompression(to priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        set(contentHugging: priority, for: axis)
        set(compressionResistance: priority, for: axis)
    }

    func set(contentHugging: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(contentHugging, for: axis)
    }

    func set(compressionResistance: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(compressionResistance, for: axis)
    }

    func isPointInsideMinimum(_ point: CGPoint) -> Bool {
        let outsetX = max(0, (minimumDimension - bounds.width) / 2)
        let outsetY = max(0, (minimumDimension - bounds.height) / 2)
        return bounds.insetBy(dx: -outsetX, dy: -outsetY).contains(point)
    }

    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: frame.midX - 6, y: frame.midY)
        animation.toValue = CGPoint(x: frame.midX + 6, y: frame.midY)
        layer.add(animation, forKey: "position")
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
