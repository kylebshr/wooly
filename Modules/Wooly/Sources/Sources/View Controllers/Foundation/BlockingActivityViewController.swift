import UIKit

class BlockingActivityViewController: ViewController {
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(indicator)
        indicator.pinCenter(to: view)
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
