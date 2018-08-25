import UIKit

extension UIFont {
    static var customBody: UIFont {
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var customCallout: UIFont {
        let font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }

    static var customDetail: UIFont {
        let font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
}
