import SafariServices

extension SFSafariViewController {
    static func makedThemedViewController(url: URL) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.preferredBarTintColor = .barColor
        viewController.preferredControlTintColor = .tintColor
        return viewController
    }
}
