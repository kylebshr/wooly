import Foundation
import Security

private struct SecurityConstant {
    static let `class` = kSecClass as String
    static let account = kSecAttrAccount as String
    static let data = kSecValueData as String
    static let genericPassword = kSecClassGenericPassword as String
    static let service = kSecAttrService as String
    static let matchLimit = kSecMatchLimit as String
    static let shouldReturnData = kSecReturnData as String
    static let matchOnlyOne = kSecMatchLimitOne as String
}

public struct Keychain<T: Any> {
    public struct KeychainError: Error {
        public let status: OSStatus
        public let message: String?

        init(status: OSStatus, message: CFString?) {
            self.status = status
            if let message = message {
                self.message = String(message)
            } else {
                self.message = nil
            }
        }

        public var localizedDescription: String {
            let error = "Keychain Error \(status)"
            if let message = self.message {
                return "\(error): \(message)"
            } else {
                return error
            }
        }
    }

    let service: String
    let account: String

    public init(service: String, account: String) {
        self.service = service
        self.account = account
    }

    private func makeQuery() -> [String: Any] {
        return [
            SecurityConstant.class: SecurityConstant.genericPassword,
            SecurityConstant.service: service,
            SecurityConstant.account: account,
        ]
    }

    private func handle(status: OSStatus) throws {
        if status != errSecSuccess {
            throw KeychainError(status: status, message: SecCopyErrorMessageString(status, nil))
        }
    }

    private func data(from value: T) -> Data {
        var value = value
        return Data(bytes: &value, count: MemoryLayout.size(ofValue: self))
    }

    func update(value: T) throws {
        let attributes = [SecurityConstant.data: data(from: value)] as CFDictionary
        let status = SecItemUpdate(makeQuery() as CFDictionary, attributes)
        try handle(status: status)
    }


    func removeValue() throws {
        let status = SecItemDelete(makeQuery() as CFDictionary)
        if status != errSecItemNotFound {
            try handle(status: status)
        }
    }

    func add(value: T) throws {
        var query = makeQuery()
        query[SecurityConstant.data] = data(from: value)
        let status = SecItemAdd(query as CFDictionary, nil)
        try handle(status: status)
    }

    func loadValue() throws -> T? {
        var query = makeQuery()
        query[SecurityConstant.shouldReturnData] = kCFBooleanTrue
        query[SecurityConstant.matchLimit] = SecurityConstant.matchOnlyOne

        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)

        if status != errSecItemNotFound {
            try handle(status: status)
        }

        return result
            .flatMap { $0 as? Data }
            .flatMap { $0.withUnsafeBytes { $0.pointee } }
    }

    public func set(value: T?) throws {
        guard let value = value else {
            return try removeValue()
        }

        if try loadValue() == nil {
            try add(value: value)
        } else {
            try update(value: value)
        }
    }

    public func value() throws -> T? {
        return try loadValue()
    }
}
