import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow()

        ThemeController.shared.add(self) { [weak window] _ in
            Appearance.apply()

            guard let window = window else { return }

            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }

        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return HandshakeService.handle(url: url)
    }
}
