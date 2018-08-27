import UIKit

@objc protocol TabBarChild: AnyObject {
    @objc var scrollView: UIScrollView? { get }
    func tabBarControllerDidSelectTab(_ controller: UITabBarController)
}

extension ViewController: TabBarChild {
    var scrollView: UIScrollView? {
        return view as? UIScrollView
    }

    func tabBarControllerDidSelectTab(_ controller: UITabBarController) {
        guard viewIfLoaded?.window != nil, let scrollView = scrollView else {
            return
        }

        let offset = CGPoint(x: 0, y: -scrollView.adjustedContentInset.top)
        scrollView.setContentOffset(offset, animated: true)
    }
}
