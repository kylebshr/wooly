import UIKit
import Siesta
import Mammut

class TimelineViewController: UIViewController {

    private var timeline: [Status] = [] {
        didSet {
            print(timeline)
        }
    }

    private let service: MastodonService

    init(service: MastodonService) {
        self.service = service

        super.init(nibName: nil, bundle: nil)

        service.home.addObserver(owner: self) { [weak self] resource, event in
            if let error = resource.latestError {
                print(error)
            }
            self?.timeline = resource.typedContent() ?? []
        }

        service.home.loadIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
    }
}
