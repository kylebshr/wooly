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

        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longpress))

        longpressGestureRecognizer.allowableMovement = 200
        longpressGestureRecognizer.minimumPressDuration = 1
        tabBar.addGestureRecognizer(longpressGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.index(of: item), let child = customChildren[index] as? TabBarChild {
            child.tabBarControllerDidSelectTab(self)
        }
    }

    @objc private func longpress(_ gesture: UILongPressGestureRecognizer) {
        if case .began = gesture.state {
            ThemeController.shared.toggleTheme()
        }
    }

}
