import UIKit
import Mammut

class MainViewController: ViewController {

    private let childTabBarController = UITabBarController()

    init(service: MastodonService) {
        super.init()

        childTabBarController.viewControllers = [
            HomeViewController(service: service),
            NotificationsViewController(),
            ExploreViewController(),
            ProfileViewController()
        ].map { NavigationController(rootViewController: $0) }

        add(child: childTabBarController)
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childTabBarController
    }
}
