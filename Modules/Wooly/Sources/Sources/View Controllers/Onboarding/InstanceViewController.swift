import UIKit
import Mammut

class InstanceViewController: TableViewController {
    typealias InstanceHandler = (Instance) -> Void

    private var instanceHandler: InstanceHandler

    private let knownInstances = [
        try! Instance(name: "mastodon.social")
    ]

    init(instanceHandler: @escaping InstanceHandler) {
        self.instanceHandler = instanceHandler
        super.init()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
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
