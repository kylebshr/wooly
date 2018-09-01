import UIKit

class Label: UILabel {
    var capHeightRelativeLayout = false {
        didSet { setNeedsLayout() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsFontForContentSizeCategory = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var alignmentRectInsets: UIEdgeInsets {
        guard capHeightRelativeLayout else {
            return super.alignmentRectInsets
        }

        var insets = UIEdgeInsets.zero
        insets.top = font.ascender - font.capHeight
        return insets
    }
}
