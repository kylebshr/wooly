import SafariServices

extension SFSafariViewController {
    static func makedThemedViewController(url: URL) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.preferredBarTintColor = .bar
        viewController.preferredControlTintColor = .tint
        return viewController
    }
}
