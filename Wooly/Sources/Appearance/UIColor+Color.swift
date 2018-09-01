import UIKit

extension UIColor {
    private static var theme: Theme {
        return ThemeController.shared.current
    }

    static var tint: UIColor {
        return UIColor(displayP3Red: 75, green: 158, blue: 235)
    }

    static var background: UIColor {
        switch theme {
        case .dark: return UIColor(displayP3Red: 30, green: 40, blue: 54)
        case .light: return .white
        case .black: return .black
        }
    }

    static var backgroundSecondary: UIColor {
        switch theme {
        case .dark: return UIColor(displayP3Red: 24, green: 31, blue: 41)
        case .light: return UIColor(displayP3Red: 234, green: 238, blue: 239)
        case .black: return UIColor(displayP3Red: 18, green: 22, blue: 25)
        }
    }

    static var bar: UIColor {
        switch theme {
        case .dark: return UIColor(displayP3Red: 23, green: 34, blue: 56)
        case .light: return .white
        case .black: return .black
        }
    }

    static var separator: UIColor {
        switch theme {
        case .dark: return .black
        case .light: return UIColor(displayP3Red: 205, green: 214, blue: 220)
        case .black: return UIColor(displayP3Red: 37, green: 38, blue: 39)
        }
    }

    static var text: UIColor {
        switch theme {
        case .dark: return .white
        case .light: return .black
        case .black: return .white
        }
    }

    static var textSecondary: UIColor {
        switch theme {
        case .dark, .black: return UIColor(displayP3Red: 139, green: 152, blue: 164)
        case .light: return UIColor(displayP3Red: 102, green: 118, blue: 131)
        }
    }

    static var highlight: UIColor {
        return backgroundSecondary
    }

    static var favorite: UIColor {
        return UIColor(displayP3Red: 244, green: 180, blue: 85)
    }

    static var reblog: UIColor {
        return UIColor(displayP3Red: 89, green: 187, blue: 109)
    }

    convenience init(displayP3Red red: Int, green: Int, blue: Int) {
        self.init(
            displayP3Red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: 1
        )
    }
}
