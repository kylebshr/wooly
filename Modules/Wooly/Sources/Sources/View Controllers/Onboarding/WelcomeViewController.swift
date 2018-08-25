import UIKit
import Mammut

class WelcomeViewController: UIViewController, Authenticator {
    private var selectedInstance: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        let instanceViewController = InstanceViewController { [weak self] instance in
            self?.didSelect(instance: instance)
        }

        add(child: instanceViewController)
    }

    private func didSelect(instance: String) {
        selectedInstance = instance
        HandshakeService.authenticate(on: instance, from: self) { success in
            guard success else {
                return print("Failed to register app")
            }
        }
    }

    func didAuthenticate(client: Client, with token: String?) {
        if let token = token, let selectedInstance = selectedInstance {
            let session = Session(instanceURL: selectedInstance, refreshToken: token, client: client)
            SessionController.shared.logIn(with: session)
        } else {
            print("Failed to authenticate user")
        }
    }
}

private class InstanceViewController: UITableViewController {
    typealias InstanceHandler = (String) -> Void

    private var instanceHandler: InstanceHandler

    private let knownInstances = [
        "mastodon.social"
    ]

    init(instanceHandler: @escaping InstanceHandler) {
        self.instanceHandler = instanceHandler
        super.init(style: .plain)
        tableView.separatorInset = .zero
        tableView.separatorColor = .separator
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .background
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InstanceCell()
        cell.set(instance: knownInstances[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knownInstances.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        instanceHandler(knownInstances[indexPath.row])
    }
}
