import UIKit
import Mammut

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    private let window = UIWindow()

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Appearance.apply()

        window.tintColor = .white
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        return true
    }
}
