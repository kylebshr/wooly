@testable import Keychain
import XCTest

class KeychainStringTests: XCTestCase {
    private let keychain = Keychain<String>(service: "this_is_a_test_service", account: "this_is_a_test_account")

    override func tearDown() {
        super.tearDown()
        try? keychain.set(value: nil)
    }

    func testUpdateNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: "test"))
        try XCTAssertNoThrow(keychain.update(value: "test"))
    }

    func testSetNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: "test"))
    }

    func testRemoveNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: "test"))
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testLoadNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: "test"))
        try XCTAssertNoThrow(keychain.loadValue())
    }

    func testEmptyRemoveNoThrow() {
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testSettingvalue() {
        let password = "Hello World"
        try? keychain.set(value: password)
        try XCTAssertEqual(keychain.value(), password)
    }

    func testRemovingvalue() {
        let password = "Hello World"
        try? keychain.set(value: password)
        try? keychain.set(value: nil)
        try XCTAssertEqual(keychain.value(), nil)
    }

    func testUpdatingvalue() {
        let password = "Hello World"
        try? keychain.set(value: "no u")
        try? keychain.set(value: password)
        try XCTAssertEqual(keychain.value(), password)

    }
}
