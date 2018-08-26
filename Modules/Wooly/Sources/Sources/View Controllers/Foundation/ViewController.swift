import UIKit

class ViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        ThemeController.shared.add(self) { [weak self] _ in
            self?.view.backgroundColor = .background
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
}
