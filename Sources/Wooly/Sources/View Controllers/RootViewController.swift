import UIKit

class RootViewController: UIViewController {

    private var viewController: UIViewController? {
        didSet {
            oldValue?.willMove(toParent: nil)
            oldValue?.view.removeFromSuperview()
            oldValue?.removeFromParent()
            if let viewController = viewController {
                addChild(viewController)
                view.addSubview(viewController.view)
                viewController.didMove(toParent: self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = UINavigationController(rootViewController: WelcomeViewController())
    }

    override var childForStatusBarStyle: UIViewController? {
        return viewController
    }
}
