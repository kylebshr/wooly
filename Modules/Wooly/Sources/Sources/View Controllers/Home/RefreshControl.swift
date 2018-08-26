import UIKit

class RefreshControl: UIControl {

    var isRefreshing: Bool = false {
        didSet {
            guard isRefreshing != oldValue else { return }
            arrow.isHidden = isRefreshing
            if isRefreshing {
                indicator.startAnimating()
                haptics.impactOccurred()
            } else {
                indicator.stopAnimating()
            }
        }
    }

    private static let height: CGFloat = 60
    private let haptics = UIImpactFeedbackGenerator()
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    private let arrow = UIImageView(image: #imageLiteral(resourceName: "Refresh Arrow"))

    override init(frame: CGRect) {
        let frame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: UIViewNoIntrinsicMetric,
            height: RefreshControl.height
        )
        super.init(frame: frame)

        addSubview(indicator)
        addSubview(arrow)
        indicator.pinCenter(to: self)
        arrow.pinCenter(to: self)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.backgroundColor = .highlight
            self?.arrow.tintColor = .textSecondary
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: RefreshControl.height)
    }

    func prepareForRefresh() {
        haptics.prepare()
    }
}
