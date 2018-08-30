import UIKit

class ContainerView: UIView {
    override class var layerClass: AnyClass {
        return CATransformLayer.self
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }
}
