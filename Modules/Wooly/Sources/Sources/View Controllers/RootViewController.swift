import UIKit
import Keychain
import Mammut

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

        SessionController.shared.observe(from: self) { [weak self] _ in
            self?.updateViewController()
        }
    }

    deinit {
        SessionController.shared.disregard(self)
    }

    // MARK: - Private methods

    private func updateViewController() {
        if let session = SessionController.shared.current,
            let service = try? MastodonService(session: session)
        {
            viewController = LoggedInViewController(service: service)
        } else {
            viewController = OnboardingViewController()
        }
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewController
    }
}
