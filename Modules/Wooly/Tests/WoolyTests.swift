@testable import Wooly
import XCTest

class UserDefaultsTests: XCTestCase {
    
    struct TestModel: Codable, Equatable {
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
        defaults?.set(codable: model, forKey: key)
        let stored: TestModel? = defaults?.codable(forKey: key)
        XCTAssertEqual(model, stored)
    }
}
