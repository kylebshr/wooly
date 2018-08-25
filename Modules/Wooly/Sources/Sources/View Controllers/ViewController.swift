import UIKit

class ViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .background
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
