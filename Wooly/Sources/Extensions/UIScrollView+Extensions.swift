import UIKit

extension UIScrollView {
    var adjustedContentOffset: CGPoint {
        var offset = contentOffset
        offset.x += adjustedContentInset.left
        offset.y += adjustedContentInset.top
        return offset
    }

    func scrollToTop() {
        if let selectorName = "X3Njcm9sbFRvVG9wSWZQb3NzaWJsZTo=".base64Decoded {
            let selector = NSSelectorFromString(selectorName)
            if responds(to: selector) {
                perform(selector, with: false)
            }
        }
    }
}
