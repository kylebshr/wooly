import UIKit

extension UIView {
    func setHuggingAndCompression(to priority: UILayoutPriority) {
        set(contentHugging: priority, for: .horizontal)
        set(contentHugging: priority, for: .vertical)
        set(compressionResistance: priority, for: .horizontal)
        set(compressionResistance: priority, for: .vertical)
    }


    func setHuggingAndCompression(to priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        set(contentHugging: priority, for: axis)
        set(compressionResistance: priority, for: axis)
    }

    func set(contentHugging: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        setContentHuggingPriority(contentHugging, for: axis)
    }

    func set(compressionResistance: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        setContentCompressionResistancePriority(compressionResistance, for: axis)
    }
}
