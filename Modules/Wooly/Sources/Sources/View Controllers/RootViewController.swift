import UIKit
import Keychain
import Mammut

private let currentInstanceKey = "currentInstance"

private extension UserDefaults {
    @objc dynamic var currentInstance: String? {
        get {
            return string(forKey: currentInstanceKey)
        }
        set {
            set(newValue, forKey: currentInstanceKey)
        }
    }

    var currentClient: Client? {
        guard let instance = currentInstance else {
            return nil
        }

        return codable(forKey: instance)
    }
}

class RootViewController: UIViewController, OnboardingViewControllerDelegate, LoggedInViewControllerDelegate {

    private var instanceObserver: NSKeyValueObservation?

    private var viewController: UIViewController? {
        didSet {
            self.switchViewControllers(old: oldValue, new: viewController)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        instanceObserver = UserDefaults.standard.observe(\.currentInstance, options: [.initial, .new]) { [weak self] _, _ in
            guard let this = self else { return }
            this.handleInstanceChange()
        }
    }

    deinit {
        instanceObserver?.invalidate()
    }

    // MARK: OnboardingViewControllerDelegate

    func didAuthenticate(client: Client, forInstance instance: String, withToken refreshToken: String) {
        self.set(refreshToken: refreshToken, forInstance: instance)
        UserDefaults.standard.set(codable: client, forKey: instance)
        UserDefaults.standard.set(instance, forKey: currentInstanceKey)
    }

    // MARK: LoggedInViewControllerDelegate

    func logOut() {
        guard let instance = UserDefaults.standard.currentInstance else { return }
        self.set(refreshToken: nil, forInstance: instance)
        UserDefaults.standard.set(nil, forKey: currentInstanceKey)
    }

    private func handleInstanceChange() {
        if let instance = UserDefaults.standard.currentInstance,
            let refreshToken = refreshToken(forInstance: instance),
            let client = UserDefaults.standard.currentClient,
            let service = try? MastodonService(session: .init(instanceURL: instance, refreshToken: refreshToken, client: client))
        {
            viewController = LoggedInViewController(service: service, delegate: self)
        } else {
            viewController = OnboardingViewController(delegate: self)
        }
    }

    private func switchViewControllers(old: UIViewController?, new: UIViewController?) {
        guard let new = new else {
            old?.remove()
            return
        }

        guard let old = old else {
            return add(child: new)
        }

        animate(from: old, to: new)
    }

    private func animate(from old: UIViewController, to new: UIViewController) {
        addChildViewController(new)
        old.willMove(toParentViewController: nil)

        let shadowView = UIView()
        shadowView.backgroundColor = .black
        shadowView.frame = view.bounds
        shadowView.alpha = 0
        view.addSubview(shadowView)

        new.view.frame = view.bounds.offsetBy(dx: 0, dy: view.bounds.height)
        view.addSubview(new.view)

        let controlPoint1 = CGPoint(x: 0.86, y: 0)
        let controlPoint2 = CGPoint(x: 0.70, y: 1)
        let animator = UIViewPropertyAnimator(duration: 0.35, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        animator.addAnimations {
            shadowView.alpha = 0.7
            new.view.frame = self.view.bounds
        }

        animator.addCompletion { _ in
            new.didMove(toParentViewController: self)
            old.view.removeFromSuperview()
            old.removeFromParentViewController()
            shadowView.removeFromSuperview()
        }

        animator.startAnimation()
    }

    private func refreshToken(forInstance instance: String) -> String? {
        return (try? Keychain(service: instance, account: "auth-token").password()) ?? nil
    }

    private func set(refreshToken: String?, forInstance instance: String) {
        try? Keychain(service: instance, account: "auth-token").set(password: refreshToken)
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewController
    }
}
