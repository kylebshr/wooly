import UIKit

class ProfileViewController: ViewController {

    override init() {
        super.init()
        title = "Profile"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "Profile Tab"), selectedImage: #imageLiteral(resourceName: "Profile Tab Selected"))
    }
}
