import UIKit
import Mammut

class WelcomeViewController: UIViewController {
    private let network = Network(baseURL: "https://mastodon.social/api/v1")
    
    var client: Client? {
        set {
            UserDefaults.standard.set(newValue, forKey: "client")
        }
        get {
            return UserDefaults.standard.codable(forKey: "client")
        }
    }
    
    private var refreshToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
    }
    
    func onboard() {
        let app = App(clientName: "wooly-ios", redirectURI: OAuth2.redirectURI)
        let request = Request(model: app, method: .post)
        
        if client != nil {
            return self.login()
        }
        
        network.perform(request: request, endpoint: "apps") { (result: Result<Client, NetworkError>) in
            switch result {
            case .success(let client):
                self.client = client
                self.login()
            case .error(let error):
                print(error)
            }
        }
    }
    
    func login() {
        OAuth2.authenticate(client: client!, from: self)
    }
}

extension WelcomeViewController: Authenticator {
    func didAuthenticate(with token: String?) {
        if let token = token {
            print("Authenticated with: \(token)")
        } else {
            print("Failed to get token")
        }
    }
}
