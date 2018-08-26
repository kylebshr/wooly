@testable import Keychain
import XCTest

class UserDefaultsTests: XCTestCase {

    struct TestModel: Storable, Equatable {
        let value: String
    }

    private var defaults: UserDefaults?
    private let suite = "WoolyTests"
    private let key = "wooly-test-key"

    override func setUp() {
        super.setUp()
        defaults?.removeSuite(named: suite)
        defaults = UserDefaults(suiteName: suite)
    }

    func testExample() {
        let model = TestModel(value: "Hello World!")
        defaults?.set(storable: model, forKey: key)
        let stored: TestModel? = defaults?.storable(forKey: key)
        XCTAssertEqual(model, stored)
    }
}
