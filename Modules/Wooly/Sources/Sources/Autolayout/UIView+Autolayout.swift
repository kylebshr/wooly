import UIKit

extension UIView {
    func pin(_ edges: UIRectEdge = .all, to view: UIView) {
        activate(constraints: [
            edges.contains(.top) ? topAnchor.constraintEqualToSystemSpacingBelow(view.topAnchor, multiplier: 1) : nil,
            edges.contains(.left) ? leadingAnchor.constraintEqualToSystemSpacingAfter(view.leadingAnchor, multiplier: 1) : nil,
            edges.contains(.right) ? view.trailingAnchor.constraintEqualToSystemSpacingAfter(trailingAnchor, multiplier: 1) : nil,
            edges.contains(.bottom) ? view.bottomAnchor.constraintEqualToSystemSpacingBelow(bottomAnchor, multiplier: 1) : nil,
        ])
    }

    func pinCenter(to view: UIView) {
        activate(constraints: [
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func activate(constraints: [NSLayoutConstraint?]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.compactMap { $0 })
    }
}
