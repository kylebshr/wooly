import UIKit
import Mammut

class LoggedInViewController: ViewController {

    private let childTabBarController = UITabBarController()

    init(service: MastodonService) {
        super.init()

        childTabBarController.viewControllers = [
            TimelineViewController(service: service)
        ].map { UINavigationController(rootViewController: $0) }

        add(child: childTabBarController)
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childTabBarController
    }
}
