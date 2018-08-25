import UIKit

class Label: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsFontForContentSizeCategory = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
