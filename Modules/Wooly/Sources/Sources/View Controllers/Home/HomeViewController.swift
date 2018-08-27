import UIKit
import Siesta
import Mammut

class HomeViewController: ViewController {

    private var timeline: [Status] = [] {
        didSet {
            tableViewController.timeline = timeline + timeline + timeline
        }
    }

    private let service: MastodonService

    private let tableViewController = TimelineTableViewController()
    private let indicatorViewController = BlockingActivityViewController()

    override var scrollView: UIScrollView? {
        return tableViewController.tableView
    }

    private var showLoading: Bool = false {
        didSet {
            if oldValue != showLoading {
                showLoading ? add(child: indicatorViewController) : indicatorViewController.remove()
            }
        }
    }

    init(service: MastodonService) {
        self.service = service
        super.init()
        title = "Home"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "Home Tab"), selectedImage: #imageLiteral(resourceName: "Home Tab Selected"), landscapeImage: #imageLiteral(resourceName: "Home Tab Landscape"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(child: tableViewController)
        tableViewController.view.pinEdges(to: view)

        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        navigationItem.rightBarButtonItem = composeButton

        tableViewController.refresh = { [weak self] completion in
            self?.service.home.load().onCompletion { _ in
                completion()
            }
        }

        service.home.addObserver(owner: self) { [weak self] resource, event in
            self?.updateTimeline(with: resource)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        service.home.loadIfNeeded()
    }

    private func updateTimeline(with resource: Resource) {
        tableViewController.refreshControl?.endRefreshing()
        timeline = resource.typedContent() ?? []
        showLoading = resource.isLoading && timeline.isEmpty

        if let error = resource.latestError {
            print(error)
        }
    }

    @objc private func compose() {
        let compose = ComposeViewController()
        let navigation = NavigationController(rootViewController: compose)
        present(navigation, animated: true, completion: nil)
    }
}
