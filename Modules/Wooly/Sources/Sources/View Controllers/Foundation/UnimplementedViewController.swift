import UIKit

class UnimplementedViewController: ViewController {

    let label = Label()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        label.textAlignment = .center
        label.pinCenter(to: view)
        label.font = .customBody
        label.text = "Unimplemented"

        ThemeController.shared.add(self) { [weak self] _ in
            self?.label.textColor = .textSecondary
        }
    }
}
