import UIKit

class RefreshControl: UIControl {

    var isAnimating: Bool = false {
        didSet {
            guard isAnimating != oldValue else { return }
            arrow.isHidden = isAnimating
            if isAnimating {
                indicator.startAnimating()
                haptics.impactOccurred()
            } else {
                indicator.stopAnimating()
            }
        }
    }

    var isRefreshing: Bool = false {
        didSet {
            guard isRefreshing, isRefreshing != oldValue else { return }
            sendActions(for: .valueChanged)
            sendActions(for: .primaryActionTriggered)
        }
    }

    private static let height: CGFloat = 60
    private let haptics = UIImpactFeedbackGenerator()
    private let indicator = UIActivityIndicatorView(style: .white)
    private let arrow = UIImageView(image: #imageLiteral(resourceName: "Refresh Arrow"))

    override init(frame: CGRect) {
        let frame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: UIView.noIntrinsicMetric,
            height: RefreshControl.height
        )
        super.init(frame: frame)

        addSubview(indicator)
        addSubview(arrow)
        indicator.pinCenter(to: self)
        arrow.pinCenter(to: self)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.arrow.tintColor = .textSecondary
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: RefreshControl.height)
    }

    func prepareForRefresh() {
        haptics.prepare()
    }
}
