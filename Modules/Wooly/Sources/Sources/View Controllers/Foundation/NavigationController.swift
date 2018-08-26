import UIKit

class NavigationController: UINavigationController {
    private var touchTimestamp: TimeInterval?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchTimestamp = touches.first?.timestamp
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first, let touchTimestamp = touchTimestamp else { return }
        if navigationBar.bounds.contains(touch.location(in: navigationBar)) {
            if touch.timestamp - touchTimestamp > 0.5 {
                ThemeController.shared.toggleTheme()
                self.touchTimestamp = nil
            }
        }
    }
}
