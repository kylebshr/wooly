import UIKit

class NotificationsViewController: ViewController {

    override init() {
        super.init()
        title = "Notifications"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "Notifications Tab"), selectedImage: #imageLiteral(resourceName: "Notifications Tab Selected"))
    }
}