import Foundation

extension URL {
    init(staticString: StaticString) {
        self = URL(string: "\(staticString)")!
    }
}
