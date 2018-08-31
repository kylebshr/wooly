import Foundation

protocol StatusViewDelegate: AnyObject {
    func setFavorite(_ favorite: Bool, on status: Status)
    func setReblog(_ reblog: Bool, on status: Status, didReblog: @escaping (Bool) -> Void)
    func reply(to status: Status)

    func didSelect(hashtag: String)
    func didSelect(account: Account)
    func didSelect(link: URL)
}
