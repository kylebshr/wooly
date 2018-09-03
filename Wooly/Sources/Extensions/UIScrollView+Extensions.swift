import UIKit

extension UIScrollView {
    var adjustedContentOffset: CGPoint {
        var offset = contentOffset
        offset.x += adjustedContentInset.left
        offset.y += adjustedContentInset.top
        return offset
    }

    func scrollToTop() {
        let partOne = "_scrollToTop"
        let partTwo = "IfPossible:"
        let selector = NSSelectorFromString(partOne + partTwo)
        if responds(to: selector) {
            perform(selector, with: false)
        }
    }
}
