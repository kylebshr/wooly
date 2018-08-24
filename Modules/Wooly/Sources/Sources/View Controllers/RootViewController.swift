import UIKit
import Keychain
import Mammut

private let currentInstanceKey = "currentInstance"

func logOut() {
    guard let instance = UserDefaults.standard.currentInstance else { return }
    set(refreshToken: nil, forInstance: instance)
    UserDefaults.standard.set(nil, forKey: currentInstanceKey)
}

private func refreshToken(forInstance instance: String) -> String? {
    return (try? Keychain(service: instance, account: "auth-token").password()) ?? nil
}

private func set(refreshToken: String?, forInstance instance: String) {
    try? Keychain(service: instance, account: "auth-token").set(password: refreshToken)
}

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
            oldValue?.remove()
            if let viewController = viewController {
                add(child: viewController)
            }
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
        set(refreshToken: refreshToken, forInstance: instance)
        UserDefaults.standard.set(codable: client, forKey: instance)
        UserDefaults.standard.set(instance, forKey: currentInstanceKey)
    }

    // MARK: LoggedInViewControllerDelegate

    func logOut() {
        guard let instance = UserDefaults.standard.currentInstance else { return }
        set(refreshToken: nil, forInstance: instance)
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

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return viewController
    }
}
