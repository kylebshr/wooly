import UIKit

class ViewController: UIViewController {
    private var didlayoutSubviews = false

    var firstResponder: UIResponder? {
        get { return nil }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        firstResponder?.becomeFirstResponder()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    @objc func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
}
