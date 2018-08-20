import Foundation

public struct App: Codable {
    var clientName: String
    var redirectUris: String
    var scopes: String
    var website: URL?
    
    public init(clientName: String, redirectURI: String = "urn:ietf:wg:oauth:2.0:oob",
         scopes: String = "read write follow", website: URL? = nil) {
        self.clientName = clientName
        self.redirectUris = redirectURI
        self.scopes = scopes
        self.website = website
    }
}

public struct Client: Codable {
    var id: String
    public var clientId: String
    var clientSecret: String
}

public enum Result<T: Codable, U: Error> {
    case success(T)
    case error(U)
}

public struct Request<Model: Codable> {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    let model: Model
    let method: Method
    
    public init(model: Model, method: Method) {
        self.model = model
        self.method = method
    }
}

public struct NetworkError: Codable, Error {
    let error: String
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        guard let url = URL(string: String(describing: value)) else {
            fatalError("Invalid URL string literal: \(value)")
        }
        self = url
    }
}

public struct Network {
    public typealias ClientCompletion<T: Codable> = (Result<T, NetworkError>) -> Void
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private let baseURL: URL
    
    public init(baseURL: URL) {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.baseURL = baseURL
    }
    
    public func perform<T: Codable, U: Codable>(request: Request<T>, endpoint: String, completion: @escaping ClientCompletion<U>) {
        guard let data = try? encoder.encode(request.model) else {
            return completion(.error(NetworkError(error: "Malformed request")))
        }
        
        let url = baseURL.appendingPathComponent(endpoint)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = data
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data, let model = try? self.decoder.decode(U.self, from: data) {
                completion(.success(model))
            } else if let data = data, let model = try? self.decoder.decode(NetworkError.self, from: data) {
                completion(.error(model))
            } else {
                completion(.error(NetworkError(error: "Unknown error")))
            }
        }
        
        task.resume()
    }
}
