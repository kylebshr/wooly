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
        tableViewController.refresh = { [weak self] sender in
            self?.service.home.load().onCompletion { _ in
                sender()
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
}
