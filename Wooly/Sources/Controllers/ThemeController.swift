import UIKit

private let themeKey = "currentTheme"

enum Theme: Int, Codable, CaseIterable {
    case light = 0
    case dark = 1
    case black = 2
}

private struct ThemeSettings: Storable {
    enum Base: Int, Codable {
        case light = 0
        case dark = 1
    }

    var base: Base
    var trueBlack: Bool

    var theme: Theme {
        switch base {
        case .light: return .light
        case .dark where trueBlack: return .black
        case .dark: return .dark
        }
    }

    static var `default` = ThemeSettings(base: .light, trueBlack: false)
}

private extension UserDefaults {
    var themeSettings: ThemeSettings {
        get {
            return UserDefaults.standard.storable(forKey: themeKey) ?? .default
        }
        set {
            UserDefaults.standard.set(storable: newValue, forKey: themeKey)
        }
    }
}

class ThemeController: Observable<Theme> {
    static let shared = ThemeController()

    private init() {
        let initial = UserDefaults.standard.themeSettings
        super.init(initial: initial.theme)
    }

    func toggleTheme() {
        let base = UserDefaults.standard.themeSettings.base
        UserDefaults.standard.themeSettings.base = ThemeSettings.Base(rawValue: (base.rawValue + 1) % 2)!

        UIView.animate(withDuration: 0.4) {
            self.current = UserDefaults.standard.themeSettings.theme
        }
    }
}
