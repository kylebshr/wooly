import UIKit

protocol Reusable {}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}

extension UITableView {
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        if let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T {
            return cell
        }

        fatalError("Cell of type \(T.identifier) not registered")
    }

    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: T.identifier)
    }
}
