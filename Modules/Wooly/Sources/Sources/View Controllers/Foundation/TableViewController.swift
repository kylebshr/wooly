import UIKit

class TableViewController: UITableViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        clearsSelectionOnViewWillAppear = false
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()

        ThemeController.shared.add(self) { [weak self] _ in
            self?.tableView.separatorColor = .separator
            self?.tableView.backgroundColor = .background
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let selectedRows = tableView.indexPathsForSelectedRows ?? []

        let deselect = { [weak self] in
            selectedRows.forEach { self?.tableView.deselectRow(at: $0, animated: animated) }
        }

        let reselect = { [weak self] (context: UIViewControllerTransitionCoordinatorContext) in
            if context.isCancelled {
                selectedRows.forEach { self?.tableView.selectRow(at: $0, animated: false, scrollPosition: .none) }
            }
        }

        guard let coordinator = transitionCoordinator else {
            return deselect()
        }

        coordinator.animate(alongsideTransition: { _ in
            deselect()
        }, completion: reselect)
    }
}
