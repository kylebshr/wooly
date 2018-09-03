import UIKit

protocol ScrollViewController {
    var scrollView: UIScrollView { get }
}

extension UITableViewController: ScrollViewController {
    var scrollView: UIScrollView {
        return tableView
    }
}

extension UICollectionViewController: ScrollViewController {
    var scrollView: UIScrollView {
        return collectionView
    }
}
