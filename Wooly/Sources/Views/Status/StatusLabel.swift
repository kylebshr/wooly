import ActiveLabel
import UIKit

class StatusLabel: ActiveLabel {

    weak var statusDelegate: StatusViewDelegate?

    private var status: Status?

    override init(frame: CGRect) {
        super.init(frame: frame)

        delegate = self
        enabledTypes = [.mention, .hashtag, .url]

        ThemeController.shared.add(self) { [weak self] _ in
            guard let this = self else { return }
            UIView.transition(with: this, duration: 0, options: [.transitionCrossDissolve], animations: {
                this.customize { label in
                    label.textColor = .text

                    label.mentionColor = .tintColor
                    label.hashtagColor = .tintColor
                    label.URLColor = .tintColor

                    let selected = UIColor.tintColor.withAlphaComponent(0.3)
                    label.mentionSelectedColor = selected
                    label.hashtagSelectedColor = selected
                    label.URLSelectedColor = selected
                }
            }, completion: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(status: Status) {
        self.status = status
        text = status.content
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }
}

extension StatusLabel: ActiveLabelDelegate {
    func didSelect(_ text: String, type: ActiveType) {
//        guard let status = status else { return }
        print("Selected \(text) type \(type)")
    }
}
