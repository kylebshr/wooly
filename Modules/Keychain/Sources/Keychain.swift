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

private extension String {
    var keychainEncoded: Data? {
        return data(using: .utf8, allowLossyConversion: false)
    }
}

public struct Keychain {
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

    func update(password: String) throws {
        let attributes = [SecurityConstant.data: password.keychainEncoded] as CFDictionary
        let status = SecItemUpdate(makeQuery() as CFDictionary, attributes)
        try handle(status: status)
    }


    func removePassword() throws {
        let status = SecItemDelete(makeQuery() as CFDictionary)
        if status != errSecItemNotFound {
            try handle(status: status)
        }
    }

    func add(password: String) throws {
        var query = makeQuery()
        query[SecurityConstant.data] = password.keychainEncoded
        let status = SecItemAdd(query as CFDictionary, nil)
        try handle(status: status)
    }

    func loadPassword() throws -> String? {
        var query = makeQuery()
        query[SecurityConstant.shouldReturnData] = kCFBooleanTrue
        query[SecurityConstant.matchLimit] = SecurityConstant.matchOnlyOne

        var result: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)

        if status != errSecItemNotFound {
            try handle(status: status)
        }

        if let result = result as? Data {
            return String.init(data: result, encoding: .utf8)
        } else {
            return nil
        }
    }

    public func set(password: String?) throws {
        guard let password = password else {
            return try removePassword()
        }

        if try loadPassword() == nil {
            try add(password: password)
        } else {
            try update(password: password)
        }
    }

    public func password() throws -> String? {
        return try loadPassword()
    }
}
