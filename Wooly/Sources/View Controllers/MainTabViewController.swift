import UIKit

class MainTabViewController: UITabBarController {

    private let customChildren: [UIViewController]

    init(service: MastodonService) {
        customChildren = [
            HomeViewController(service: service),
            ExploreViewController(),
            NotificationsViewController(),
            ProfileViewController()
        ]

        super.init(nibName: nil, bundle: nil)

        viewControllers = customChildren.map { NavigationController(rootViewController: $0) }
        tabBar.addGestureRecognizer(UILongPressGestureRecognizer.makeThemeChangingGesture())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item),
            let child = customChildren[index] as? UIViewController & TabBarChild,
            child.view.window != nil {
            child.tabBarControllerDidSelectTab(self)
        }
    }
}
