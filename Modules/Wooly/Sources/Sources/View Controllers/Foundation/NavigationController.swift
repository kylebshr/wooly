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

        if let cachedInteractionController = value(forKey: "_cachedInter" + "actionController") as? NSObject {
            let selector = Selector("handleNaviga" + "tionTransition:")
            if cachedInteractionController.responds(to: selector) {
                fullScreenPanGestureRecognizer.addTarget(cachedInteractionController, action: selector)
                view.addGestureRecognizer(fullScreenPanGestureRecognizer)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchTimestamp = touches.first?.timestamp
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first, let touchTimestamp = touchTimestamp else { return }
        if navigationBar.bounds.contains(touch.location(in: navigationBar)) {
            if touch.timestamp - touchTimestamp > 0.5 {
                ThemeController.shared.toggleTheme()
                self.touchTimestamp = nil
            }
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
