import UIKit

extension UIScrollView {
    var adjustedContentOffset: CGPoint {
        var offset = contentOffset
        offset.x += adjustedContentInset.left
        offset.y += adjustedContentInset.top
        return offset
    }
}
