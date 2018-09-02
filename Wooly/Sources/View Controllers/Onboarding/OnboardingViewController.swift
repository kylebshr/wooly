import UIKit

private let appName = "Wooly"
private let website = URL(staticString: "https://wooly.social")
private let redirectURI = "com.kylebashour.Wooly://oath2"

class OnboardingViewController: ViewController, Authenticator {
    private let welcomeView = WelcomeIntroView()
    private let textField = TextField()
    private let exampleLabel = Label()

    private var enteredInstance: Instance?

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardTap)
        view.backgroundColor = .background

        textField.placeholder = "Enter an instance"
        textField.enablesReturnKeyAutomatically = true
        textField.autocapitalizationType = .none
        textField.keyboardType = .URL
        textField.returnKeyType = .go
        textField.delegate = self

        exampleLabel.text = "ex. mastodon.social"
        exampleLabel.numberOfLines = 0
        exampleLabel.font = .footnote
        exampleLabel.textAlignment = .center
        exampleLabel.textColor = .textSecondary

        let topSpace = UIView()
        let bottomSpace = UIView()

        let stack = UIStackView(arrangedSubviews: [topSpace, welcomeView, bottomSpace, textField, exampleLabel])
        stack.spacing = .standardHorizontalEdge
        stack.axis = .vertical

        view.addSubview(stack)
        stack.pinEdges([.left, .right], to: view.safeAreaLayoutGuide, insets: .standardEdges)
        stack.topAnchor.pin(to: view.safeAreaLayoutGuide.topAnchor, priority: .defaultLow)
        stack.bottomAnchor.pin(lessThan: view.safeAreaLayoutGuide.bottomAnchor,
                               constant: -.standardHorizontalEdge)
        textField.bottomAnchor.pin(to: keyboardLayoutGuide.bottomAnchor, constant: -.standardHorizontalEdge,
                                   priority: .medium)
        textField.widthAnchor.pin(to: stack.widthAnchor)
        topSpace.heightAnchor.pin(to: bottomSpace.heightAnchor)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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

extension OnboardingViewController: UITextFieldDelegate {
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
