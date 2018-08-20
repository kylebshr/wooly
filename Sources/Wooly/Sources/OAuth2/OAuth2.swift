import UIKit
import Mammut
import SafariServices

protocol Authenticator {
    func didAuthenticate(with token: String?)
}

struct OAuth2 {
    typealias AuthenticatorViewController = UIViewController & Authenticator
    static let redirectURI = "com.kylebashour.Wooly://oath2"
    
    private static var currentViewController: AuthenticatorViewController?
    
    static func handle(url: URL) -> Bool {
        var token: String?
        
        defer {
            currentViewController?.dismiss(animated: true) {
                self.currentViewController?.didAuthenticate(with: token)
            }
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let firstItem = components.queryItems?.first, firstItem.name == "code" else {
            return false
        }
    
        token = firstItem.value
        return true
    }
    
    static func authenticate(client: Client, from viewController: AuthenticatorViewController) {
        self.currentViewController = viewController
        let parameters = [
            URLQueryItem(name: "scope", value: "read write follow"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "client_id", value: client.clientId)
        ]
        
        var components = URLComponents(string: "https://mastodon.social/oauth/authorize")!
        components.queryItems = parameters
        let safariViewController = SFSafariViewController(url: components.url!)
        viewController.present(safariViewController, animated: true, completion: nil)
    }
}
