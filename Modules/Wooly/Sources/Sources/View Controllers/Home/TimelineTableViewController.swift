import AsyncDisplayKit
import UIKit
import Mammut

class TimelineTableViewController: ASViewController<ASTableNode>, ASTableDataSource, ASTableDelegate {
    var timeline: [Status] = [] {
        didSet {
            tableNode.reloadData()
        }
    }

    var refresh: ((@escaping () -> Void) -> Void)?

    private let customRefreshControl = RefreshControl()

    private let tableNode: ASTableNode

    var tableView: UITableView {
        return tableNode.view
    }

    init() {
        tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self

        ThemeController.shared.add(self) { [weak self] _ in
            self?.tableView.separatorColor = .separator
            self?.tableView.backgroundColor = .backgroundSecondary
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.register(TimelineStatusCell.self)
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 140

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
        })
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(StatusDetailViewController(), animated: true)
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let status = timeline[indexPath.row]

        return {
            let cell = TimelineStatusNode()
            cell.display(status: status)
            return cell
        }
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return timeline.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: TimelineStatusCell = tableView.dequeue(for: indexPath)
//        cell.display(status: timeline[indexPath.row])
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        navigationController?.pushViewController(StatusDetailViewController(), animated: true)
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalOffset = -scrollView.adjustedContentOffset.y

        if verticalOffset >= customRefreshControl.bounds.height && scrollView.isTracking {
            customRefreshControl.isAnimating = true
        } else if verticalOffset > 0 {
            customRefreshControl.prepareForRefresh()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if customRefreshControl.isAnimating {
            self.tableView.contentInset.top = self.customRefreshControl.bounds.height
        } else {
            self.tableView.contentInset.top = 0
        }

        if !decelerate, customRefreshControl.isAnimating  {
            customRefreshControl.isRefreshing = true
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if customRefreshControl.isAnimating {
            customRefreshControl.isRefreshing = true
        }
    }
}
