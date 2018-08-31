import UIKit

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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        view.addSubview(customRefreshControl)
        customRefreshControl.widthAnchor.pin(to: view.widthAnchor)
        customRefreshControl.centerXAnchor.pin(to: view.centerXAnchor)
        customRefreshControl.bottomAnchor.pin(to: view.topAnchor)
        customRefreshControl.addTarget(self, action: #selector(refreshChanged), for: .primaryActionTriggered)
    }

    @objc private func refreshChanged(_ sender: UIRefreshControl) {
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
            self.tableView.contentInset.top = 0
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TimelineStatusCell = tableView.dequeue(for: indexPath)
        cell.delegate = self
        cell.display(status: timeline[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = viewController(at: indexPath) {
            navigationController?.pushViewController(viewController, animated: true)
        }
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
        if customRefreshControl.isAnimating {
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

    override func viewController(at indexPath: IndexPath) -> UIViewController? {
        return StatusDetailViewController()
    }
}

extension TimelineTableViewController: StatusViewDelegate {
    func didSelect(hashtag: String) {
        print("Hashtag! \(hashtag)")
    }

    func didSelect(account: String) {
        print("Account! \(account)")
    }

    func didSelect(link: URL) {
        print("Link! \(link)")
    }

    func setFavorite(_ favorite: Bool, on status: Status) {
        print("Favorite!")
    }

    func setReblog(_ reblog: Bool, on status: Status, didReblog: @escaping (Bool) -> Void) {
        guard reblog else { return }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Boost", style: .default, handler: { _ in didReblog(true) }))
        alertController.addAction(UIAlertAction(title: "Boost with Comment", style: .default, handler: { _ in didReblog(true) }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func reply(to status: Status) {
        let compose = ComposeViewController()
        present(NavigationController(rootViewController: compose), animated: true, completion: nil)
    }
}