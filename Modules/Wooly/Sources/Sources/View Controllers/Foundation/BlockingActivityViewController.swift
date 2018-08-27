import UIKit

class BlockingActivityViewController: ViewController {
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(indicator)
        indicator.pinCenter(to: view)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.view.backgroundColor = .background
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        indicator.stopAnimating()
    }
}
