import UIKit
import Mammut

class OnboardingViewController: ViewController {

    private let welcomeViewController = WelcomeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationController = UINavigationController(rootViewController: welcomeViewController)
        add(child: navigationController)
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.first
    }
}
