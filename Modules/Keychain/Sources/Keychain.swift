import Foundation
import Security

/// Represents an error thrown by Keychain
struct KeychainError: Error {

    /// The status code of the error
    let status: OSStatus

    static func unhandledError(status: OSStatus) -> KeychainError {
        return KeychainError(status: status)
    }

    var localizedDescription: String {
        if let message = SecCopyErrorMessageString(status, nil) {
            return message as String
        } else {
            return "Unknown keychain error \(status)"
        }
    }
}

/// Wraps the system keychain for easy storage of any type
public class Keychain<T: Any> {

    private let service: String
    private let account: String

    /// Get or set a new value
    public var value: T? {
        get {
            return try? loadValue()
        }
        set {
            try? removeValue()
            if let value = newValue {
                try? add(value: value)
            }
        }
    }

    /// Create a new Keychain
    ///
    /// - parameter service: The service the object is associated with
    /// - parameter account: The account the object is associated with
    public init(service: String, account: String) {
        self.service = service
        self.account = account
    }

    // MARK: - Private methods

    private func makeQuery() -> [CFString: Any] {
        return [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ]
    }

    private func data(from value: T) -> Data {
        var value = value
        return Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
    }

    // MARK: - Internal methods

    func update(value: T) throws {
        let attributes = [kSecValueData: data(from: value)] as CFDictionary
        let status = SecItemUpdate(makeQuery() as CFDictionary, attributes)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }


    func removeValue() throws {
        let status = SecItemDelete(makeQuery() as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func add(value: T) throws {
        var query = makeQuery()
        query[kSecValueData] = data(from: value)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func loadValue() throws -> T {
        var query = makeQuery()
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne

        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }

        let value: T? = result
            .flatMap { $0 as? Data }
            .flatMap { $0.withUnsafeBytes { $0.pointee } }

        if let value = value {
            return value
        } else {
            try removeValue()
            throw KeychainError.unhandledError(status: -1)
        }
    }
}
