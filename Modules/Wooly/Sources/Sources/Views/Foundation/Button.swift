import UIKit

private let minimumDimension: CGFloat = 50

class Button: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let outsetX = max(0, (minimumDimension - self.bounds.width) / 2)
        let outsetY = max(0, (minimumDimension - self.bounds.height) / 2)
        return self.bounds.insetBy(dx: -outsetX, dy: -outsetY).contains(point)
    }
}
