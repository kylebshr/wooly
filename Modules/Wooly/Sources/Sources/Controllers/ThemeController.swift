import UIKit
import Keychain

private let themeKey = "currentTheme"

enum Theme: Int, Codable, CaseIterable {
    case light = 0
    case dark = 1
    case black = 2
}

class ThemeController: Observable<Theme> {
    static let shared = ThemeController()

    private init() {
        let initial: StorableBox<Theme>? = UserDefaults.standard.storable(forKey: themeKey)
        super.init(initial: initial?.value ?? .light)
    }

    func toggleTheme() {
        UIView.animate(withDuration: 0.2) {
            self.current = Theme(rawValue: (self.current.rawValue + 1) % Theme.allCases.count)!
        }

        let storableTheme = StorableBox<Theme>(current)
        UserDefaults.standard.set(storable: storableTheme, forKey: themeKey)
    }
}
