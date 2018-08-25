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

class SessionController {
    static let shared = SessionController()

    private var observation: NSKeyValueObservation?
    private var observers: [AnyHashable: (Session?) -> Void] = [:]

    var current: Session? {
        guard let instance = UserDefaults.standard.currentInstance else {
            return nil
        }

        return keychain(for: instance).value
    }

    func observe(from observer: AnyHashable, handler: @escaping (Session?) -> Void) {
        handler(current)
        observers[observer] = handler
    }

    func disregard(_ observer: AnyHashable) {
        observers[observer] = nil
    }

    private init() {
        observation = UserDefaults.standard.observe(\UserDefaults.currentInstance, options: [.new]) {
            [weak self] _, _ in
            guard let this = self else { return }
            this.observers.values.forEach { $0(this.current) }
        }
    }

    deinit {
        observation?.invalidate()
    }

    private func keychain(for instance: String) -> Keychain<Session> {
        return .init(service: instance, account: sessionStorageKey)
    }

    func logIn(with session: Session) {
        keychain(for: session.instance.name).value = session
        UserDefaults.standard.currentInstance = session.instance.name
    }

    func logOut() {
        guard let session = current else { return }
        keychain(for: session.instance.name).value = nil
        UserDefaults.standard.currentInstance = nil

    }
}
