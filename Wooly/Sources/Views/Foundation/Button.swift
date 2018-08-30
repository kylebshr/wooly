import UIKit

class Button: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }
}
