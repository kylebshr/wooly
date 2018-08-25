import UIKit

extension UIView {
    func setHuggingAndCompression(to priority: UILayoutPriority) {
        set(hugging: priority, for: .horizontal)
        set(hugging: priority, for: .vertical)
        set(compression: priority, for: .horizontal)
        set(compression: priority, for: .vertical)
    }


    func setHuggingAndCompression(to priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        set(hugging: priority, for: axis)
        set(compression: priority, for: axis)
    }

    func set(hugging: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        setContentHuggingPriority(hugging, for: axis)
    }

    func set(compression: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        setContentCompressionResistancePriority(compression, for: axis)
    }
}
