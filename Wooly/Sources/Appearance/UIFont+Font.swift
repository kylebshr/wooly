import UIKit

extension UIFont {
    static var largeTitle: UIFont {
        let font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var title1: UIFont {
        let font = UIFont.systemFont(ofSize: 28, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var title2: UIFont {
        let font = UIFont.systemFont(ofSize: 22, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var title3: UIFont {
        let font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var body: UIFont {
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var callout: UIFont {
        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var detail: UIFont {
        let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var footnote: UIFont {
        let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
}
