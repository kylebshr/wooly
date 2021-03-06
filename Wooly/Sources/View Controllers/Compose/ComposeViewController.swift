import UIKit

class ComposeViewController: ViewController {
    private let tootButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(sendToot))

    private let avatarControl = AvatarControl()
    private let textView = TextView()

    private let service: MastodonService
    private let inReplyTo: Status?

    override var firstResponder: UIResponder? {
        return textView
    }

    init(service: MastodonService, replyingTo inReplyTo: Status? = nil) {
        self.service = service
        self.inReplyTo = inReplyTo
        super.init()
        service.currentUser.addObserver(owner: self) { [weak self] resource, _ in
            if let account: Account = resource.typedContent() {
                self?.avatarControl.url = account.avatar
            }
        }.loadIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Toot"

        view.addSubview(avatarControl)
        avatarControl.pinEdges([.left, .top], to: view.safeAreaLayoutGuide, insets: .standardEdges)
        avatarControl.pinSize(to: 35)
        avatarControl.isUserInteractionEnabled = false

        view.addSubview(textView)
        textView.centerYAnchor.pin(to: avatarControl.centerYAnchor, priority: .medium)
        textView.topAnchor.pin(greaterThan: view.safeAreaLayoutGuide.topAnchor, constant: .mediumSpacing)
        textView.trailingAnchor.pin(to: view.trailingAnchor, constant: -.largeSpacing)
        textView.leadingAnchor.pin(to: avatarControl.trailingAnchor, constant: .standardSpacing)
        textView.delegate = self
        textView.font = .title3
        configurePlaceholder()

        tootButton.isEnabled = false
        navigationItem.rightBarButtonItem = tootButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                                           action: #selector(dismissAnimated))

        ThemeController.shared.add(self) { [weak self] _ in
            self?.view.backgroundColor = .background
        }
    }

    @objc private func sendToot() {
        textView.resignFirstResponder()
        textView.becomeFirstResponder()
        service.post(status: textView.text, replyingTo: inReplyTo?.id).onSuccess { _ in
            self.service.home.load()
        }
        dismissAnimated()
    }

    private func configurePlaceholder() {
        if let status = inReplyTo {
            textView.placeholder = "Replying to \(status.account.displayName)"

            var cachedAcct = ""
            if let cachedAccount: Account = service.currentUser.typedContent() {
                cachedAcct = cachedAccount.acct
            }

            let mentions = status.mentions
                .map { $0.acct }
                .filter { $0 != cachedAcct }
                .reduce("") { $0 + "@\($1) " }

            let initialText = "@\(status.account.acct) \(mentions)"
            textView.text = initialText
        } else {
            textView.placeholder = "What’s on your mind?"
        }

    }
}

extension ComposeViewController: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        tootButton.isEnabled = !textView.text.isEmpty
    }
}
