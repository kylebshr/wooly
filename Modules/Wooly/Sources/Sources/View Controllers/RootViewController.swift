import UIKit
import Keychain
import Mammut

class RootViewController: ViewController {
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

        SessionController.shared.add(self) { [weak self] _ in
            self?.updateViewController()
        }
    }

    // MARK: - Private methods

    private func updateViewController() {
        if let service = SessionController.shared.makeService() {
            viewController = MainTabViewController(service: service)
        } else {
            viewController = OnboardingViewController()
        }
    }

    override var childForStatusBarStyle: UIViewController? {
        return viewController
    }
}
