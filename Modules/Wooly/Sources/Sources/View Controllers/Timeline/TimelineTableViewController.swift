import UIKit
import Mammut

class TimelineTableViewController: TableViewController {
    var timeline: [Status] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TimelineStatusCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.tableView.indexPathsForSelectedRows?.forEach { [weak self] in
                self?.tableView.deselectRow(at: $0, animated: false)
            }
        }, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TimelineStatusCell = tableView.dequeue(for: indexPath)
        cell.display(status: timeline[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(StatusDetailViewController(), animated: true)
    }
}
