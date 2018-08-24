import UIKit

class RootViewController: UIViewController {

    private var viewController: UIViewController? {
        didSet {
            oldValue?.remove()
            if let viewController = viewController {
                add(child: viewController)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = OnboardingViewController()
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewController
    }
}
