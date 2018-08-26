import UIKit
import Keychain

private let themeKey = "currentTheme"

enum Theme: String, Codable {
    case light = "light"
    case dark = "dark"
}

class ThemeController: Observable<Theme> {
    static let shared = ThemeController()

    private init() {
        let initial: StorableBox<Theme>? = UserDefaults.standard.storable(forKey: themeKey)
        super.init(initial: initial?.value ?? .light)
    }

    func toggleTheme() {
        UIView.animate(withDuration: 0.2) {
            switch self.current {
            case .dark: self.current = .light
            case .light: self.current = .dark
            }
        }

        let storableTheme = StorableBox<Theme>(current)
        UserDefaults.standard.set(storable: storableTheme, forKey: themeKey)
    }
}
