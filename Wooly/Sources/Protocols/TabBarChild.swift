import UIKit

protocol TabBarChild: AnyObject {
    func tabBarControllerDidSelectTab(_ controller: UITabBarController)
}

protocol TabBarTableViewController: TabBarChild {
    var tableView: UITableView { get }
}

extension TabBarChild where Self: TabBarTableViewController {
    func tabBarControllerDidSelectTab(_ controller: UITabBarController) {
        guard tableView.numberOfRows(inSection: 0) > 0 else { return }

        let topIndexPath = IndexPath(row: 0, section: 0)
        // With estimated row heights, `scrollToRow(at:)` can be inaccurate if the cached row heights are invalidated.
        // Asking for the rect of the top index path forces a content size calculation and `scrollToRow` works.
        _ = tableView.rectForRow(at: topIndexPath)
        tableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
    }
}
