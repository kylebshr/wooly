import UIKit
import Mammut

class TableViewController: UITableViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        clearsSelectionOnViewWillAppear = false
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()

        registerForPreviewing(with: self, sourceView: view)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.tableView.separatorColor = .separator
            self?.tableView.backgroundColor = .backgroundSecondary
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleDeselection(animated: animated)
    }

    private func handleDeselection(animated: Bool) {
        let selectedRows = tableView.indexPathsForSelectedRows ?? []

        guard let coordinator = transitionCoordinator else {
            for row in selectedRows { tableView.deselectRow(at: row, animated: animated) }
            return
        }

        coordinator.animate(
            alongsideTransition:{ [weak self] _ in
                for row in selectedRows { self?.tableView.deselectRow(at: row, animated: false) }
            }, completion: { [weak self] context in
                guard context.isCancelled else { return }
                for row in selectedRows { self?.tableView.selectRow(at: row, animated: false, scrollPosition: .none) }
            }
        )
    }

    func viewController(at indexPath: IndexPath) -> UIViewController? {
        return nil
    }
}

extension TableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }

        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        return viewController(at: indexPath)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
}
