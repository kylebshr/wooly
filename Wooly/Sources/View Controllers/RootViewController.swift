import UIKit

class RootViewController: ViewController {
    private var viewController: UIViewController? {
        didSet {
            oldValue?.remove()
            if let viewController = viewController {
                add(child: viewController)
            }
        }
    }

    override init() {
        super.init()

        let viewController = ViewController()
        viewController.view.backgroundColor = .background
        let navigationController = NavigationController(rootViewController: viewController)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController]

        self.viewController = tabBarController
        add(child: tabBarController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SessionController.shared.add(self) { [weak self] _ in
            self?.updateViewController()
        }
    }

    override var childForStatusBarStyle: UIViewController? {
        return viewController
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return viewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    // MARK: - Private methods

    private func updateViewController() {
        if let service = SessionController.shared.makeService() {
            viewController = MainTabViewController(service: service)
        } else {
            viewController = OnboardingViewController()
        }
    }
}
