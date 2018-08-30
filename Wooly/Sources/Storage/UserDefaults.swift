import Foundation

public extension UserDefaults {
    func set<T: Storable>(storable value: T?, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }

        set(data, forKey: key)
    }

    func storable<T: Storable>(forKey key: String) -> T? {
        guard let data = value(forKey: key) as? Data, let value = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }

        return value
    }
}
