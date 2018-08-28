import Foundation
import Mammut
import Keychain

private let currentInstanceKey = "currentInstance"
private let sessionKey = "currentMastodonSession"
private let authenticationTokenKey = "currentAuthenticationToken"

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

    private var session: Session? {
        guard let instance = UserDefaults.standard.currentInstance else {
            return nil
        }

        return sessionKeychain(for: instance).value
    }

    private init() {
        super.init(initial: nil)
        current = session
        observation = UserDefaults.standard.observe(\UserDefaults.currentInstance, options: [.new]) { [weak self] _, _ in
            self?.current = self?.session
        }
    }

    deinit {
        observation?.invalidate()
    }

    private func sessionKeychain(for instance: String) -> Keychain<Session> {
        return Keychain(service: instance, account: sessionKey)
    }

    private func authKeychain(for session: Session) -> Keychain<StorableBox<String>> {
        let accountKey = session.client.id + authenticationTokenKey
        return Keychain(service: session.instance.name, account: accountKey)
    }

    func logIn(with session: Session) {
        sessionKeychain(for: session.instance.name).value = session
        UserDefaults.standard.currentInstance = session.instance.name
    }

    func logOut() {
        defer { UserDefaults.standard.currentInstance = nil }
        guard let session = session else { return }
        authKeychain(for: session).value = nil
        sessionKeychain(for: session.instance.name).value = nil
    }

    func makeService() -> MastodonService? {
        guard let session = session else { return nil }
        let tokenKeychain = authKeychain(for: session)
        return MastodonService(session: session, tokenStorage: tokenKeychain)
    }
}
