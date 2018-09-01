import UIKit

class ContainerView: UIView {
    override class var layerClass: AnyClass {
        return CATransformLayer.self
    }

    var child: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let child = child {
                addSubview(child)
                child.pinEdges(to: self)
            }
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }
}
