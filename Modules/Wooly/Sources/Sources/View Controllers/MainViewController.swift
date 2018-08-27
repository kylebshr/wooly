import UIKit
import Mammut

class MainViewController: UITabBarController {

    private let children: [UIViewController & TabBarChild]

    init(service: MastodonService) {
        children = [
            HomeViewController(service: service),
            NotificationsViewController(),
            ExploreViewController(),
            ProfileViewController()
        ]

        super.init(nibName: nil, bundle: nil)

        viewControllers = children.map { NavigationController(rootViewController: $0) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item) {
            children[index].tabBarControllerDidSelectTab(self)
        }
    }
}
