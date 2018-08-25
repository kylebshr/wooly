import UIKit
import Mammut

class TimelineTableViewController: UITableViewController {
    var timeline: [Status] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TimelineStatusCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero
        tableView.separatorColor = .separator
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TimelineStatusCell = tableView.dequeue(for: indexPath)
        cell.status = timeline[indexPath.row]
        return cell
    }
}
