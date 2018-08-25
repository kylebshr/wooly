@testable import Keychain
import XCTest

class KeychainTests: XCTestCase {
    private let keychain = Keychain<String>(service: "this_is_a_test_service", account: "this_is_a_test_account")

    override func tearDown() {
        super.tearDown()
        keychain.value = nil
    }

    func testSettingValue() {
        keychain.value = #function
        XCTAssertEqual(keychain.value, #function)
    }

    func testRemovingValue() {
        keychain.value = #function
        keychain.value = nil
        XCTAssertEqual(keychain.value, nil)
    }

    func testRemoveWithNoValue() {
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testRemoveWithValue() {
        keychain.value = #function
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testAddWithNoValue() {
        try XCTAssertNoThrow(keychain.add(value: #function))
    }

    func testAddWithValue() {
        keychain.value = #function
        try XCTAssertThrowsError(keychain.add(value: #function))
    }

    func testUpdateWithNoValue() {
        try XCTAssertThrowsError(keychain.update(value: #function))
    }

    func testUpdateWithValue() {
        keychain.value = #function
        try XCTAssertNoThrow(keychain.update(value: #function))
    }

    func testLoadNoValue() {
        try XCTAssertThrowsError(keychain.loadValue())
    }

    func testLoadValue() {
        keychain.value = #function
        try XCTAssertNoThrow(keychain.loadValue())
    }
}
