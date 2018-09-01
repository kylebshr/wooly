import UIKit

class ComposeViewController: ViewController {
    private let avatarControl = AvatarControl()
    private let textView = TextView()

    override var firstResponder: UIResponder? {
        return textView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Toot"

        view.addSubview(avatarControl)
        avatarControl.pinEdges([.left, .top], to: view.safeAreaLayoutGuide, insets: .standardEdges)
        avatarControl.pinSize(to: 38)
        avatarControl.isUserInteractionEnabled = false

        view.addSubview(textView)
        textView.centerYAnchor.pin(to: avatarControl.centerYAnchor, priority: .medium)
        textView.topAnchor.pin(greaterThan: view.safeAreaLayoutGuide.topAnchor, constant: .standardVerticalEdge)
        textView.trailingAnchor.pin(to: view.trailingAnchor, constant: -.rightHorizontalEdge)
        textView.leadingAnchor.pin(to: avatarControl.trailingAnchor, constant: .standardSpacing)
        textView.placeholder = "What’s on your mind?"
        textView.font = .title3

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                                           action: #selector(dismissAnimated))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toot", style: .done, target: nil, action: nil)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.view.backgroundColor = .background
        }
    }
}
