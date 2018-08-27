import UIKit
import Mammut

class MainViewController: UITabBarController {

    private let customChildren: [UIViewController & TabBarChild]

    init(service: MastodonService) {
        customChildren = [
            HomeViewController(service: service),
            NotificationsViewController(),
            ExploreViewController(),
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
}
