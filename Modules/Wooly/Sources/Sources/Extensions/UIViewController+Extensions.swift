import UIKit

extension UIViewController {
    func add(child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.view.pinEdges(to: view)
        child.didMove(toParentViewController: self)
    }

    func remove() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
