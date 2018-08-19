import UIKit
import Mammut

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    private let window = UIWindow()
    private let network = Network(baseURL: "https://mastodon.social/api/v1")
    
    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Appearance.apply()

        window.tintColor = .white
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        
        let app = App(clientName: "wooly-ios")
        let request = Request(model: app, method: .post)

        network.perform(request: request, endpoint: "apps") { (result: Result<Client, NetworkError>) in
            switch result {
            case .success(let client):
                print(client)
            case .error(let error):
                print(error)
            }
        }
        
        return true
    }
}
