import UIKit
import Mammut

private let appName = "Wooly for iOS"
private let website = URL(staticString: "https://wooly.social")
private let redirectURI = "com.kylebashour.Wooly://oath2"

class WelcomeViewController: ViewController, Authenticator {
    private var selectedInstance: Instance?

    private lazy var instanceViewController = InstanceViewController { [weak self] instance in
        self?.didSelect(instance: instance)
    }

    private var instanceView: UIView {
        return instanceViewController.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(child: instanceViewController)

        instanceView.layer.borderWidth = .pixel
        instanceView.layer.cornerRadius = .standardSpacing
        instanceView.pinEdges([.left, .right, .bottom], to: view.safeAreaLayoutGuide, insets: .standardEdges)
        instanceView.heightAnchor.pin(to: 300)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.instanceView.layer.borderColor = UIColor.separator.cgColor
            self?.view.backgroundColor = .backgroundSecondary
        }
    }

    private func didSelect(instance: Instance) {
        selectedInstance = instance
        let app = App(clientName: appName, redirectURI: redirectURI, website: website)
        HandshakeService.authenticate(app: app, on: instance, from: self) { success in
            guard success else {
                return print("Failed to register app")
            }
        }
    }

    func didAuthenticate(client: Client, with token: String?) {
        if let token = token, let selectedInstance = selectedInstance {
            let session = Session(instance: selectedInstance, client: client, refreshToken: token)
            SessionController.shared.logIn(with: session)
        } else {
            print("Failed to authenticate user")
        }
    }
}
