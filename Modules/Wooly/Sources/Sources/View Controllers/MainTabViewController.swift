import UIKit
import Mammut

class MainTabViewController: UITabBarController {

    private let customChildren: [UIViewController & TabBarChild]

    init(service: MastodonService) {
        customChildren = [
            HomeViewController(service: service),
            ExploreViewController(),
            NotificationsViewController(),
            ProfileViewController()
        ]

        super.init(nibName: nil, bundle: nil)

        viewControllers = customChildren.map { NavigationController(rootViewController: $0) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item) {
            customChildren[index].tabBarControllerDidSelectTab(self)
        }
    }

    private func bounceTab(at index: Int) {
        let item = tabBar.subviews[index + 1]
        item.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7) {
            item.transform = .identity
        }.startAnimation()
    }
}
