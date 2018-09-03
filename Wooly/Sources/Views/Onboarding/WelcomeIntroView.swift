import UIKit

class WelcomeIntroView: ContainerView {
    let iconImageView = UIImageView()
    let welcomeLabel = Label()
    let appNameLabel = Label()
    let instructionsLabel = Label()

    override init(frame: CGRect) {
        super.init(frame: frame)

        iconImageView.image = #imageLiteral(resourceName: "In App Icon")

        welcomeLabel.text = "Welcome to"
        welcomeLabel.font = .largeTitle

        appNameLabel.text = "Wooly"
        appNameLabel.font = .largeTitle

        instructionsLabel.text = "Browse Mastodon from a beautiful, native and (not yet) powerful app. Sign in to any instance to get started."
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = .body

        let stackedViews = [iconImageView, welcomeLabel, appNameLabel, instructionsLabel]
        let stack = StackView(arrangedSubviews: stackedViews)
        stack.setCustomSpacing(0, after: welcomeLabel)
        stack.spacing = .standardSpacing
        stack.alignment = .leading
        stack.axis = .vertical

        addSubview(stack)
        stack.pinEdges(to: self, insets: .standardEdges)

        ThemeController.shared.add(self) { [weak self] _ in
            self?.welcomeLabel.textColor = .text
            self?.appNameLabel.textColor = .tint
            self?.instructionsLabel.textColor = .text
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
