import UIKit

private let themeKey = "currentTheme"

enum Theme: String, Codable {
    case light = "light"
    case dark = "dark"
}

class ThemeController: Observable<Theme> {
    static let shared = ThemeController()

    private init() {
        let initial: Theme = UserDefaults.standard.codable(forKey: themeKey) ?? .light
        super.init(initial: initial)
    }

    func toggleTheme() {
        UIView.animate(withDuration: 0.2) {
            switch self.current {
            case .dark: self.current = .light
            case .light: self.current = .dark
            }
        }
    }
}
