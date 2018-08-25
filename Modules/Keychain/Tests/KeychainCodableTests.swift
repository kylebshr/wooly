@testable import Keychain
import XCTest

class KeychainCodableTests: XCTestCase {
    struct Model: Equatable {
        let foo: String
        let bar: Int
    }

    private let model = Model(foo: "test", bar: 1234)
    private let keychain = Keychain<Model>(service: "this_is_a_test_service", account: "this_is_a_test_account")

    override func tearDown() {
        super.tearDown()
        try? keychain.set(value: nil)
    }

    func testUpdateNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: model))
        try XCTAssertNoThrow(keychain.update(value: Model(foo: "new", bar: 4321)))
    }

    func testSetNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: model))
    }

    func testRemoveNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: model))
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testLoadNoThrow() {
        try XCTAssertNoThrow(keychain.set(value: model))
        try XCTAssertNoThrow(keychain.loadValue())
    }

    func testEmptyRemoveNoThrow() {
        try XCTAssertNoThrow(keychain.removeValue())
    }

    func testSettingvalue() {
        let password = Model(foo: "Password", bar: 8)
        try? keychain.set(value: password)
        try XCTAssertEqual(keychain.value(), password)
    }

    func testRemovingvalue() {
        let password = Model(foo: "Password", bar: 8)
        try? keychain.set(value: password)
        try? keychain.set(value: nil)
        try XCTAssertEqual(keychain.value(), nil)
    }

    func testUpdatingvalue() {
        let password = Model(foo: "Password", bar: 8)
        try? keychain.set(value: Model(foo: "no u", bar: 8))
        try? keychain.set(value: password)
        try XCTAssertEqual(keychain.value(), password)

    }
}
