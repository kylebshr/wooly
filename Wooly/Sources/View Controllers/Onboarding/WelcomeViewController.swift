import UIKit

private let appName = "Wooly"
private let website = URL(staticString: "https://wooly.social")
private let redirectURI = "com.kylebashour.Wooly://oath2"

class WelcomeViewController: ViewController, Authenticator {
    private let titleLabel = Label()
    private let textField = TextField()
    private let exampleLabel = Label()
    private let iconView = UIImageView(image: #imageLiteral(resourceName: "In App Icon"))

    private var enteredInstance: Instance?

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardTap)
        view.backgroundColor = .background

        textField.placeholder = "mastodon.social"
        textField.enablesReturnKeyAutomatically = true
        textField.autocapitalizationType = .none
        textField.keyboardType = .URL
        textField.returnKeyType = .go
        textField.delegate = self

        titleLabel.text = "Welcome to Wooly!\n🛠🚧👷‍♂️"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = .title1
        titleLabel.textColor = .text

        exampleLabel.text = "Enter an instance to get started"
        exampleLabel.numberOfLines = 0
        exampleLabel.font = .footnote
        exampleLabel.textAlignment = .center
        exampleLabel.textColor = .textSecondary

        let topSpace = UIView()
        let bottomSpace = UIView()

        let stack = UIStackView(arrangedSubviews: [topSpace, iconView, titleLabel, bottomSpace, textField, exampleLabel])
        stack.spacing = .standardVerticalEdge
        stack.alignment = .center
        stack.axis = .vertical

        view.addSubview(stack)
        stack.pinEdges([.left, .right, .top], to: view.safeAreaLayoutGuide, insets: .standardEdges)
        stack.bottomAnchor.pin(lessThan: view.safeAreaLayoutGuide.bottomAnchor,
                               constant: -.standardVerticalEdge)
        textField.bottomAnchor.pin(to: keyboardLayoutGuide.bottomAnchor, constant: -.standardVerticalEdge,
                                   priority: .medium)
        textField.widthAnchor.pin(to: stack.widthAnchor)
        topSpace.heightAnchor.pin(to: bottomSpace.heightAnchor, multiplier: 0.5)
    }

    private func didEnter(instance: Instance) {
        enteredInstance = instance
        let app = App(clientName: appName, redirectURI: redirectURI, website: website)
        HandshakeService.authenticate(app: app, on: instance, from: self) { success in
            guard success else {
                return print("Failed to register app")
            }
        }
    }

    func didAuthenticate(client: Client, with token: String?) {
        if let token = token, let enteredInstance = enteredInstance {
            let session = Session(instance: enteredInstance, client: client, refreshToken: token)
            SessionController.shared.logIn(with: session)
        } else {
            print("Failed to authenticate user")
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension WelcomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, let instance = try? Instance(name: text) {
            didEnter(instance: instance)
            textField.resignFirstResponder()
        } else {
            textField.shake()
        }

        return true
    }
}
