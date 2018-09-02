import Foundation

public struct Instance: Codable, Equatable {
    public enum InstanceError: Error {
        case invalidName
    }

    public let name: String
    public let url: URL

    public init(name: String) throws {
        let host = URL(string: name)?.host ?? name
        guard host.split(separator: ".").count > 1 else {
            throw InstanceError.invalidName
        }

        var components = URLComponents()
        components.host = host
        components.scheme = "https"

        self.name = host
        self.url = try components.url ?? {
            throw InstanceError.invalidName
        }()
    }
}
