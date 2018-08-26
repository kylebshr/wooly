import UIKit

class ExploreViewController: UnimplementedViewController {

    override init() {
        super.init()
        title = "Explore"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "Explore Tab"), selectedImage: #imageLiteral(resourceName: "Explore Tab Selected"), landscapeImage: #imageLiteral(resourceName: "Explore Tab Lanscape"))
    }
}
