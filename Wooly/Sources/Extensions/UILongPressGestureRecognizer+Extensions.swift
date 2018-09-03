import UIKit

extension UILongPressGestureRecognizer {
    static func makeThemeChangingGesture() -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(
            target: UILongPressGestureRecognizer.self,
            action: #selector(UILongPressGestureRecognizer.toggleTheme)
        )

        gesture.minimumPressDuration = 0.5
        gesture.allowableMovement = 44

        return gesture
    }

    @objc private static func toggleTheme(_ sender: UILongPressGestureRecognizer) {
        if case .began = sender.state {
            ThemeController.shared.toggleTheme()
        }
    }
}
