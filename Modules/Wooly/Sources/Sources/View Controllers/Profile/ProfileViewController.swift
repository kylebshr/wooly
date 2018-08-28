import UIKit

class ProfileViewController: UnimplementedViewController {

    override init() {
        super.init()
        title = "Profile"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "Profile Tab"), selectedImage: #imageLiteral(resourceName: "Profile Tab Selected"), landscapeImage: #imageLiteral(resourceName: "Profile Tab Landscape"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let logoutButton = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(self.logOutTapped))
        navigationItem.leftBarButtonItem = logoutButton
    }

    @objc
    private func logOutTapped() {
        SessionController.shared.logOut()
    }
}
