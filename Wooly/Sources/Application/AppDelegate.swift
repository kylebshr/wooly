import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    private let window = UIWindow()
    
    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ThemeController.shared.add(self) { [weak self] _ in
            Appearance.apply()

            guard let this = self else { return }

            for view in this.window.subviews {
                view.removeFromSuperview()
                this.window.addSubview(view)
            }
        }

        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return HandshakeService.handle(url: url)
    }
}
