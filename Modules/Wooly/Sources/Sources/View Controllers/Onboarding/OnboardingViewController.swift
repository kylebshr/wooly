import UIKit
import Mammut

protocol OnboardingViewControllerDelegate: AnyObject {
    func didAuthenticate(client: Client, forInstance instance: String, withToken refreshToken: String)
}

class OnboardingViewController: UIViewController {

    weak var delegate: OnboardingViewControllerDelegate? {
        didSet { welcomeViewController.delegate = delegate }
    }

    private let welcomeViewController = InstanceSelectionViewController()

    init(delegate: OnboardingViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        welcomeViewController.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationController = UINavigationController(rootViewController: welcomeViewController)
        add(child: navigationController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return childViewControllers.first
    }
}
