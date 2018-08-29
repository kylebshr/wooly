import UIKit
import Mammut

class StatusActionView: UIView {

    private let replyButton = StatusActionButton(image: #imageLiteral(resourceName: "Reply"))
    private let reblogButton = StatusActionButton(image: #imageLiteral(resourceName: "Reblog"), selectedImage: #imageLiteral(resourceName: "Reblog Selected"), haptics: true)
    private let favoriteButton = StatusActionButton(image: #imageLiteral(resourceName: "Favorite"), selectedImage: #imageLiteral(resourceName: "Favorite Selected"), haptics: true)

    override init(frame: CGRect) {
        super.init(frame: frame)

        let buttons = [replyButton, reblogButton, favoriteButton]
        let guides = [UILayoutGuide(), UILayoutGuide(), UILayoutGuide()]

        for (index, (button, layoutGuide)) in zip(buttons, guides).enumerated() {
            addSubview(button)
            addLayoutGuide(layoutGuide)

            button.pinEdges([.top, .bottom], to: self)
            button.leadingAnchor.pin(to: layoutGuide.trailingAnchor)

            layoutGuide.widthAnchor.pin(to: widthAnchor, multiplier: CGFloat(index) / CGFloat(buttons.count))
            layoutGuide.leadingAnchor.pin(to: leadingAnchor)
        }

        ThemeController.shared.add(self) { [weak self] _ in
            buttons.forEach { $0.tintColor = .textSecondary }
            self?.replyButton.selectedColor = .textSecondary
            self?.reblogButton.selectedColor = .reblogColor
            self?.favoriteButton.selectedColor = .favoriteColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }

    func display(status: Status) {
        replyButton.title = title(for: status.repliesCount)
        reblogButton.title = title(for: status.reblogsCount)
        favoriteButton.title = title(for: status.favouritesCount)
        reblogButton.isSelected = status.reblogged ?? false
        favoriteButton.isSelected = status.favourited ?? false
    }

    private func title(for count: Int) -> String? {
        return count == 0 ? nil : String(count)
    }
}
