import UIKit
import Mammut

class TimelineTableViewController: TableViewController {
    var timeline: [Status] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var refresh: ((@escaping () -> Void) -> Void)?

    private let customRefreshControl = RefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TimelineStatusCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        view.addSubview(customRefreshControl)
        customRefreshControl.widthAnchor.pin(to: view.widthAnchor)
        customRefreshControl.centerXAnchor.pin(to: view.centerXAnchor)
        customRefreshControl.bottomAnchor.pin(to: view.topAnchor)
        customRefreshControl.addTarget(self, action: #selector(refreshChanged), for: .primaryActionTriggered)
    }

    @objc private func refreshChanged(_ sender: UIRefreshControl) {
        print("refreshChanged")
        refresh? { [weak self] in
            self?.endRefreshing()
        }
    }

    private func endRefreshing() {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.contentInset.top = 0
        }, completion: { _ in
            self.customRefreshControl.isAnimating = false
            self.customRefreshControl.isRefreshing = false
        })
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

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalOffset = -scrollView.adjustedContentOffset.y

        if verticalOffset >= customRefreshControl.bounds.height && scrollView.isTracking {
            customRefreshControl.isAnimating = true
        } else if verticalOffset > 0 {
            customRefreshControl.prepareForRefresh()
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if customRefreshControl.isAnimating && scrollView.adjustedContentOffset.y < 0 {
            self.tableView.contentInset.top = self.customRefreshControl.bounds.height
        } else {
            self.tableView.contentInset.top = 0
        }

        if !decelerate, customRefreshControl.isAnimating  {
            customRefreshControl.isRefreshing = true
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if customRefreshControl.isAnimating {
            customRefreshControl.isRefreshing = true
        }
    }
}
