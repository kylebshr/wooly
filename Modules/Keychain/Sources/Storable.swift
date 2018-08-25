import Foundation

public protocol Storable: Codable {}

public struct StorableBox<T: Codable>: Storable {
    public let value: T

    public init(_ value: T) {
        self.value = value
    }
}
