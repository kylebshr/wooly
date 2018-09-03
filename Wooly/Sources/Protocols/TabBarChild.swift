import UIKit

protocol TabBarChild: AnyObject {
    func tabBarControllerDidSelectTab(_ controller: UITabBarController)
}

extension TabBarChild where Self: ScrollViewController {
    func tabBarControllerDidSelectTab(_ controller: UITabBarController) {
        scrollView.scrollToTop()
    }
}
