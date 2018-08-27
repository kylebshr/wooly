import UIKit

class StatusActionView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let replyButton = UIButton(type: .system)
        replyButton.setImage(#imageLiteral(resourceName: "Reply"), for: .normal)

        let boostButton = UIButton(type: .system)
        boostButton.setImage(#imageLiteral(resourceName: "Boost"), for: .normal)

        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(#imageLiteral(resourceName: "Favorite"), for: .normal)

        let buttons = [replyButton, boostButton, favoriteButton]
        let guides = [UILayoutGuide(), UILayoutGuide(), UILayoutGuide()]

        for (index, (button, layoutGuide)) in zip(buttons, guides).enumerated() {
            addSubview(button)
            addLayoutGuide(layoutGuide)

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

    func display(replies: Int, boosts: Int, favorites: Int) {
        
    }
}
