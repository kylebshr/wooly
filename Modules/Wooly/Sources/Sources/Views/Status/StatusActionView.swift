import UIKit

class StatusActionView: UIView {

    private let haptics = UIImpactFeedbackGenerator()

    private let replyButton = Button(type: .system)
    private let boostButton = Button(type: .system)
    private let favoriteButton = Button(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        replyButton.setImage(#imageLiteral(resourceName: "Reply"), for: .normal)
        boostButton.setImage(#imageLiteral(resourceName: "Boost"), for: .normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "Favorite"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(self.playHaptics), for: .primaryActionTriggered)

        let buttons = [replyButton, boostButton, favoriteButton]
        let guides = [UILayoutGuide(), UILayoutGuide(), UILayoutGuide()]

        for (index, (button, layoutGuide)) in zip(buttons, guides).enumerated() {
            addSubview(button)
            addLayoutGuide(layoutGuide)

            button.titleLabel?.font = .footnote
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: .extraSmallSpacing, bottom: 0, right: -.extraSmallSpacing)
            button.pinEdges([.top, .bottom], to: self)
            button.leadingAnchor.pin(to: layoutGuide.trailingAnchor)

            layoutGuide.widthAnchor.pin(to: widthAnchor, multiplier: CGFloat(index) / CGFloat(buttons.count))
            layoutGuide.leadingAnchor.pin(to: leadingAnchor)
        }

        ThemeController.shared.add(self) { _ in
            buttons.forEach { $0.tintColor = .textSecondary }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }

    func display(boosts: Int, favorites: Int) {
        boostButton.setTitle(String(boosts), for: .normal)
        favoriteButton.setTitle(String(favorites), for: .normal)
    }

    @objc private func playHaptics() {
        haptics.impactOccurred()
    }
}
