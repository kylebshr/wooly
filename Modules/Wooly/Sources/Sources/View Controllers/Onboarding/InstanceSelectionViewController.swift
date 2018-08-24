import UIKit
import Mammut

class InstanceSelectionViewController: UIViewController, Authenticator {

    weak var delegate: OnboardingViewControllerDelegate?

    private var selectedInstance: String?

    override func viewDidLoad() {
        super.viewDidLoad()

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
            delegate?.didAuthenticate(client: client, forInstance: selectedInstance, withToken: token)
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = knownInstances[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knownInstances.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        instanceHandler(knownInstances[indexPath.row])
    }
}