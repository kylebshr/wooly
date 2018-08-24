@testable import Keychain
import XCTest

class KeychainTests: XCTestCase {
    private let keychain = Keychain(service: "this_is_a_test_service", account: "this_is_a_test_account")

    override func tearDown() {
        super.tearDown()
        try? keychain.set(password: nil)
    }

    func testUpdateNoThrow() {
        try XCTAssertNoThrow(keychain.set(password: "test"))
        try XCTAssertNoThrow(keychain.update(password: "test"))
    }

    func testSetNoThrow() {
        try XCTAssertNoThrow(keychain.set(password: "test"))
    }

    func testRemoveNoThrow() {
        try XCTAssertNoThrow(keychain.set(password: "test"))
        try XCTAssertNoThrow(keychain.removePassword())
    }

    func testLoadNoThrow() {
        try XCTAssertNoThrow(keychain.set(password: "test"))
        try XCTAssertNoThrow(keychain.loadPassword())
    }

    func testEmptyRemoveNoThrow() {
        try XCTAssertNoThrow(keychain.removePassword())
    }

    func testSettingPassword() {
        let password = "Hello World"
        try? keychain.set(password: password)
        try XCTAssertEqual(keychain.password(), password)
    }

    func testRemovingPassword() {
        let password = "Hello World"
        try? keychain.set(password: password)
        try? keychain.set(password: nil)
        try XCTAssertEqual(keychain.password(), nil)
    }

    func testUpdatingPassword() {
        let password = "Hello World"
        try? keychain.set(password: "no u")
        try? keychain.set(password: password)
        try XCTAssertEqual(keychain.password(), password)

    }
}
