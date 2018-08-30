import UIKit

class OnboardingViewController: ViewController {

    private let welcomeViewController = WelcomeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationController = UINavigationController(rootViewController: welcomeViewController)
        add(child: navigationController)
    }

    override var childForStatusBarStyle: UIViewController? {
        return children.first
    }
}
