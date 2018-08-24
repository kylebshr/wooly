import UIKit
import Mammut

protocol LoggedInViewControllerDelegate: AnyObject {
    func logOut()
}

class LoggedInViewController: UIViewController {

    private let childTabBarController = UITabBarController()

    weak var delegate: LoggedInViewControllerDelegate?

    init(service: MastodonService, delegate: LoggedInViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)

        childTabBarController.viewControllers = [
            TimelineViewController(service: service)
        ].map { UINavigationController(rootViewController: $0) }

        add(child: childTabBarController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childTabBarController
    }
}
