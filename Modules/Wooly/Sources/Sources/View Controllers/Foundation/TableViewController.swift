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

        guard let coordinator = transitionCoordinator else {
            for row in selectedRows { tableView.deselectRow(at: row, animated: animated) }
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            for row in selectedRows { self?.tableView.deselectRow(at: row, animated: false) }
        }, completion: { [weak self] context in
            if context.isCancelled {
                for row in selectedRows { self?.tableView.selectRow(at: row, animated: false, scrollPosition: .none) }
            }
        })
    }
}
