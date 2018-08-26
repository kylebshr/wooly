@testable import Keychain
import XCTest

class KeychainTests: XCTestCase {

    struct TestModel: Storable, Equatable {
        let value: String

        init(_ value: String = #function) {
            self.value = value
        }
    }

    private let keychain = Keychain<TestModel>(service: "this_is_a_test_service", account: "this_is_a_test_account")

    override func tearDown() {
        super.tearDown()
        keychain.value = nil
    }

    func testSettingValue() {
        keychain.value = TestModel()
        XCTAssertEqual(keychain.value, TestModel())
    }

    func testRemovingValue() {
        keychain.value = TestModel()
        keychain.value = nil
        XCTAssertEqual(keychain.value, nil)
    }

    func testRemoveWithNoValue() {
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testRemoveWithValue() {
        keychain.value = TestModel()
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testAddWithNoValue() {
        try XCTAssertNoThrow(keychain.add(value: TestModel()))
    }

    func testAddWithValue() {
        keychain.value = TestModel()
        try XCTAssertThrowsError(keychain.add(value: TestModel()))
    }

    func testUpdateWithNoValue() {
        try XCTAssertThrowsError(keychain.update(value: TestModel()))
    }

    func testUpdateWithValue() {
        keychain.value = TestModel()
        try XCTAssertNoThrow(keychain.update(value: TestModel()))
    }

    func testLoadNoValue() {
        try XCTAssertThrowsError(keychain.loadValue())
    }

    func testLoadValue() {
        keychain.value = TestModel()
        try XCTAssertNoThrow(keychain.loadValue())
    }
}
