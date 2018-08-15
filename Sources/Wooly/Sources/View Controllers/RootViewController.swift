import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationController = UINavigationController(rootViewController: WelcomeViewController())
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
    }
}
