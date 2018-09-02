import UIKit

extension StackView {
    @discardableResult func add(spacing: CGFloat, after view: UIView) -> UIView? {
        guard let index = arrangedSubviews.firstIndex(of: view) else {
            return nil
        }

        let spacer = ContainerView()
        spacer.isUserInteractionEnabled = false
        spacer.heightAnchor.pin(to: spacing, priority: .almostRequired)
        spacer.widthAnchor.pin(to: spacing, priority: .almostRequired)
        insertArrangedSubview(spacer, at: index + 1)
        return spacer
    }

    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
