import UIKit

class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        if !layer.masksToBounds {
            layer.masksToBounds = true
        }
    }
}
