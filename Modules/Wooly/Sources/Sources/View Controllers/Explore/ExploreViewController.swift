import UIKit

class ExploreViewController: ViewController {

    override init() {
        super.init()
        title = "Explore"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "Explore Tab"), selectedImage: #imageLiteral(resourceName: "Explore Tab Selected"))
    }
}
