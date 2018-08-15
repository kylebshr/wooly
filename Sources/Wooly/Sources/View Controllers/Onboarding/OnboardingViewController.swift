import UIKit

class OnboardingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let welcomeViewController = WelcomeViewController()
        let navigationController = UINavigationController(rootViewController: welcomeViewController)
        add(child: navigationController)
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.first
    }
}
