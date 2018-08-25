import UIKit
import Mammut

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

        instanceView.layer.borderColor = UIColor.separator.cgColor
        instanceView.layer.borderWidth = 1 / UIScreen.main.scale
        instanceView.layer.cornerRadius = .standardSpacing
        instanceView.pinEdges([.left, .right, .bottom], to: view.safeAreaLayoutGuide, insets: .standardEdges)
        instanceView.heightAnchor.pin(to: 300)
    }

    private func didSelect(instance: Instance) {
        selectedInstance = instance
        HandshakeService.authenticate(on: instance, from: self) { success in
            guard success else {
                return print("Failed to register app")
            }
        }
    }

    func didAuthenticate(client: Client, with token: String?) {
        if let token = token, let selectedInstance = selectedInstance {
            let session = Session(instance: selectedInstance, client: client, refreshToken: token)
            SessionController.logIn(with: session)
        } else {
            print("Failed to authenticate user")
        }
    }
}
