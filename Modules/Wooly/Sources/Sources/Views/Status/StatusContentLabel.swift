import UIKit
import ActiveLabel

class StatusContentLabel: ActiveLabel {

    override init(frame: CGRect) {
        super.init(frame: frame)

        adjustsFontForContentSizeCategory = true

        ThemeController.shared.add(self) { [weak self] _ in
            self?.customize { label in
                label.textColor = .text
                label.mentionColor = .tintColor
                label.URLColor = .tintColor
                label.hashtagColor = .tintColor
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
