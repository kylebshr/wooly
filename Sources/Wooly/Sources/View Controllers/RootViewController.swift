import UIKit

class RootViewController: UIViewController {

    private var viewController: UIViewController? {
        didSet {
            oldValue?.willMove(toParentViewController: nil)
            oldValue?.view.removeFromSuperview()
            oldValue?.removeFromParentViewController()
            if let viewController = viewController {
                addChildViewController(viewController)
                view.addSubview(viewController.view)
                viewController.didMove(toParentViewController: self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = UINavigationController(rootViewController: WelcomeViewController())
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewController
    }
}
