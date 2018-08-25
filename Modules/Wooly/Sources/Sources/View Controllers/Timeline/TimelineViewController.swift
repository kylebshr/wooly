import UIKit
import Siesta
import Mammut

class TimelineViewController: ViewController {

    private var timeline: [Status] = [] {
        didSet {
            tableViewController.timeline = timeline
        }
    }

    private let service: MastodonService

    private let tableViewController = TimelineTableViewController()
    private let indicatorViewController = ActivityIndicatorViewController()

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(child: tableViewController)

        let logoutButton = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(self.logOutTapped))
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.title = "Home"

        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)

        service.home.addObserver(owner: self) { [weak self] resource, event in
            self?.updateTimeline(with: resource)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        service.home.loadIfNeeded()
    }

    private func updateTimeline(with resource: Resource) {
        if let error = resource.latestError {
            fatalError("\(error)")
        }
        timeline = resource.typedContent() ?? []
        showLoading = resource.isLoading && timeline.isEmpty
    }

    @objc
    private func logOutTapped() {
        SessionController.shared.logOut()
    }
}
