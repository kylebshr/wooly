import UIKit
import Siesta

class HomeViewController: ViewController, TabBarChild {

    private var timeline: [Status] = [] {
        didSet {
            tableViewController.timeline = timeline
        }
    }

    private let service: MastodonService

    private let tableViewController: TimelineTableViewController
    private let indicatorViewController = BlockingActivityViewController()

    private var showLoading: Bool = false {
        didSet {
            if oldValue != showLoading {
                showLoading ? add(child: indicatorViewController) : indicatorViewController.remove()
            }
        }
    }

    init(service: MastodonService) {
        self.tableViewController = TimelineTableViewController(service: service)
        self.service = service
        super.init()
        title = "Home"
        tabBarItem = UITabBarItem(title: title, image: #imageLiteral(resourceName: "Home Tab"), selectedImage: #imageLiteral(resourceName: "Home Tab Selected"), landscapeImage: #imageLiteral(resourceName: "Home Tab Landscape"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(child: tableViewController)

        let composeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Compose.pdf"), landscapeImagePhone: #imageLiteral(resourceName: "Compose Landscape.pdf"), style: .plain,
                                            target: self, action: #selector(compose))
        navigationItem.rightBarButtonItem = composeButton

        service.home.addObserver(owner: self) { [weak self] resource, event in
            print(event)
            self?.updateTimeline(with: resource)
        }.load()
    }

    private func updateTimeline(with resource: Resource) {
        timeline = resource.typedContent() ?? []
        showLoading = resource.isLoading && timeline.isEmpty

        if let error = resource.latestError {
            print(error)
        }
    }

    @objc private func compose() {
        let compose = ComposeViewController(service: service)
        let navigation = NavigationController(rootViewController: compose)
        present(navigation, animated: true, completion: nil)
    }
}

extension HomeViewController: ScrollViewController {
    var scrollView: UIScrollView {
        return tableViewController.tableView
    }
}
