import Foundation
import Mammut
import Keychain

private let currentInstanceKey = "currentInstance"
private let sessionStorageKey = "currentMastodonSession"

private extension UserDefaults {
    @objc dynamic var currentInstance: String? {
        get {
            return string(forKey: currentInstanceKey)
        }
        set {
            set(newValue, forKey: currentInstanceKey)
        }
    }
}

class SessionController: Observable<Session?> {
    static let shared = SessionController()

    private var observation: NSKeyValueObservation?

    private static var session: Session? {
        guard let instance = UserDefaults.standard.currentInstance else {
            return nil
        }

        return keychain(for: instance).value
    }

    private init() {
        super.init(initial: SessionController.session)
        observation = UserDefaults.standard.observe(\UserDefaults.currentInstance, options: [.new]) { [weak self] _, _ in
            self?.current = SessionController.session
        }
    }

    deinit {
        observation?.invalidate()
    }

    private static func keychain(for instance: String) -> Keychain<Session> {
        return Keychain(service: instance, account: sessionStorageKey)
    }

    static func logIn(with session: Session) {
        keychain(for: session.instance.name).value = session
        UserDefaults.standard.currentInstance = session.instance.name
    }

    static func logOut() {
        defer { UserDefaults.standard.currentInstance = nil }
        guard let session = session else { return }
        keychain(for: session.instance.name).value = nil
    }
}
