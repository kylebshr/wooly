import UIKit

class StatusLabel: ActiveLabel {

    weak var statusDelegate: StatusViewDelegate?

    var status: Status? {
        didSet { if let status = status { self.display(status: status) } }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsFontForContentSizeCategory = true

        font = .body
        numberOfLines = 0
        urlMaximumLength = 56
        delegate = self
        enabledTypes = [.mention, .hashtag, .url]

        ThemeController.shared.add(self) { [weak self] _ in
            guard let this = self else { return }
            UIView.transition(with: this, duration: 0, options: .transitionCrossDissolve, animations: {
                this.customize { label in
                    label.textColor = .text

                    label.mentionColor = .tint
                    label.hashtagColor = .tint
                    label.URLColor = .tint

                    let selected = UIColor.tint.withAlphaComponent(0.3)
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

    private func display(status: Status) {
        let mentionIDs = status.mentions.map { $0.id }
        set(text: status.content, mentionIDs: mentionIDs)
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return isPointInsideMinimum(point)
    }
}

extension StatusLabel: ActiveLabelDelegate {
    func didSelect(_ text: String, type: ActiveType) {
        switch type {
        case .mention:
            statusDelegate?.didSelect(account: text)
        case .hashtag:
            statusDelegate?.didSelect(hashtag: text)
        case .url:
            if let url = URL(string: text) {
                statusDelegate?.didSelect(link: url)
            }
        case .custom:
            break
        }
    }
}
