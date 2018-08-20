import Foundation

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()

extension UserDefaults {
    func set<T: Codable>(_ value: T?, forKey key: String) {
        guard let data = try? encoder.encode(value) else {
            return
        }
        
        set(data, forKey: key)
    }
    
    func value<T: Codable>(forKey key: String) -> T? {
        guard let data = value(forKey: key) as? Data, let value = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        
        return value
    }
}
