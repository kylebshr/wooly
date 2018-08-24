import UIKit

class OnboardingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let welcomeViewController = InstanceSelectionViewController()
        let navigationController = UINavigationController(rootViewController: welcomeViewController)
        add(child: navigationController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.first
    }
}
