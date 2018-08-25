import UIKit
import Mammut

class WelcomeViewController: ViewController, Authenticator {
    private var selectedInstance: Instance?

    override func viewDidLoad() {
        super.viewDidLoad()

        let instanceViewController = InstanceViewController { [weak self] instance in
            self?.didSelect(instance: instance)
        }

        add(child: instanceViewController)
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
            SessionController.shared.logIn(with: session)
        } else {
            print("Failed to authenticate user")
        }
    }
}
