import UIKit

class ComposeViewController: UnimplementedViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAnimated))

        let v = StatusActionView()
        view.addSubview(v)
        v.pinEdges([.top, .right, .left], to: view.safeAreaLayoutGuide)
    }
}
