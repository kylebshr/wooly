import UIKit
import Mammut

class WelcomeViewController: UIViewController {
    private let network = Network(baseURL: "https://mastodon.social/api/v1")    
    private let oauthNetwork = Network(baseURL: "https://mastodon.social")

    var client: Client? {
        set { UserDefaults.standard.set(codable: newValue, forKey: "client") }
        get { return UserDefaults.standard.codable(forKey: "client") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = nil
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.addTarget(self, action: #selector(onboard), for: .primaryActionTriggered)
        button.sizeToFit()
        button.center = view.center
        view.addSubview(button)
        view.backgroundColor = .background
    }
    
    @objc
    func onboard() {
//        return loadTimeline()
//        
//        let app = App(clientName: "wooly-ios", redirectURI: OAuth2.redirectURI)
//        let request = Request(model: app, method: .post)
//        
//        if client != nil {
//            return self.login()
//        }
//        
//        network.perform(request: request, endpoint: "apps") { (result: Result<Client, NetworkError>) in
//            switch result {
//            case .success(let client):
//                self.client = client
//                self.login()
//            case .error(let error):
//                print(error)
//            }
//        }
    }
    
    func login() {
//        OAuth2.authenticate(client: client!, from: self)
    }
    
    func fetchAuthToken(using refreshToken: String) {
//        let params = [
//            "client_id": client!.clientId,
//            "client_secret": client!.clientSecret,
//            "grant_type": "refresh_token",
//            "refresh_token": refreshToken
//        ]
//        
//        oauthNetwork.performRequest(with: "oauth/token", parameters: params) { (result: Result<String, NetworkError>) in
//                
//        }
//        
//        let token = RefreshToken(client: client!, refreshToken: refreshToken, redirectURI: OAuth2.redirectURI)
//        let request = Request(model: token, method: .post)

//        oauthNetwork.perform(request: request, endpoint: "oauth/token") { (result: Result<String, NetworkError>) in

//        }
    }
    
    func loadTimeline() {
        let options = TimelineOptions()
        let request = Requestt(model: options, method: .get)
        network.perform(request: request, endpoint: "timelines/home") { (result: Result<[Status], NetworkError>) in
            switch result {
            case .success(let timeline):
                for status in timeline {
                    print(status.content.withoutHtmlTags)
                }
            case .error(let error):
                print(error)
            }
        }
    }
}

extension String {
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

extension WelcomeViewController: Authenticator {
    func didAuthenticate(with token: String?) {
        if let token = token {
            fetchAuthToken(using: token)
        } else {
            print("Failed to get token")
        }
    }
}
