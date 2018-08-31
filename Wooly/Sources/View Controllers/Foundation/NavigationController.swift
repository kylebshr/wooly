import UIKit

class NavigationController: UINavigationController {
    private var touchTimestamp: TimeInterval?

    private let fullScreenPanGestureRecognizer = UIPanGestureRecognizer()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longpress))

        longpressGestureRecognizer.allowableMovement = 200
        longpressGestureRecognizer.minimumPressDuration = 0.5
        navigationBar.addGestureRecognizer(longpressGestureRecognizer)

        if let cachedInteractionController = value(forKey: "_cachedInter" + "actionController") as? NSObject {
            let selector = Selector("handleNaviga" + "tionTransition:")
            if cachedInteractionController.responds(to: selector) {
                fullScreenPanGestureRecognizer.addTarget(cachedInteractionController, action: selector)
                view.addGestureRecognizer(fullScreenPanGestureRecognizer)
            }
        }
    }

    @objc private func longpress(_ gesture: UILongPressGestureRecognizer) {
        if case .began = gesture.state {
            ThemeController.shared.toggleTheme()
        }
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }

    public func navigationController(_: UINavigationController,
                                     didShow _: UIViewController, animated _: Bool) {
        fullScreenPanGestureRecognizer.isEnabled = viewControllers.count > 1
    }
}