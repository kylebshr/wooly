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

    override init() {
        super.init()
        viewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        SessionController.shared.add(self) { [weak self] _ in
            self?.updateViewController()
        }
    }

    // MARK: - Private methods

    private func updateViewController() {
        if let session = SessionController.shared.current,
            let service = try? MastodonService(session: session)
        {
            viewController = MainViewController(service: service)
        } else {
            viewController = OnboardingViewController()
        }
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewController
    }
}
