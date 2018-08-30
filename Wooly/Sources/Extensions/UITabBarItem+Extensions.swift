import UIKit

extension UITabBarItem {
    convenience init(title: String?, image: UIImage, selectedImage: UIImage, landscapeImage: UIImage) {
        self.init(title: title, image: image, selectedImage: selectedImage)
        self.landscapeImagePhone = landscapeImage
    }
}
