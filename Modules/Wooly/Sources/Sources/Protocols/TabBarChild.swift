import UIKit

protocol TabBarChild {
    func tabBarControllerDidSelectTab(_ controller: UITabBarController)
}

extension UIViewController: TabBarChild {
    func tabBarControllerDidSelectTab(_ controller: UITabBarController) {
        guard viewIfLoaded?.window != nil, let view = view as? UIScrollView else {
            return
        }

        let offset = CGPoint(x: 0, y: -view.adjustedContentInset.top)
        view.setContentOffset(offset, animated: true)
    }
}
