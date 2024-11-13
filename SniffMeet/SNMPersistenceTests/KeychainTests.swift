//
//  KeychainTests.swift
//  SniffMeet
//
//  Created by sole on 11/13/24.
//

import XCTest

final class KeychainTests: XCTestCase {
    private var keychainManager: KeychainManager!
    private let testKey: String = "test"

    override func setUp() {
        keychainManager = KeychainManager.shared
    }
    override func tearDown() {
        try? keychainManager.delete(forKey: testKey)
    }

    func test_delete에서_삭제할_값이_없으면_에러를_반환한다() {
        // given
        // when
        // then
        XCTAssertThrowsError(try keychainManager.delete(forKey: testKey)) { error in
            XCTAssert(error is KeychainError)
            XCTAssertEqual(error as! KeychainError, KeychainError.keyNotFound)
        }
    }
    func test_delete에서_삭제할_값이_있으면_삭제한다() throws {
        // given
        try keychainManager.set(value: "123", forKey: testKey)
        // when
        // then
        try keychainManager.delete(forKey: testKey)
    }
    func test_set에서_이미_값이_존재하면_값을_덮어씌운다() throws {
        // given
        try keychainManager.set(value: "123", forKey: testKey)
        // when
        try keychainManager.set(value: "234", forKey: testKey)
        // then
        let value = try keychainManager.get(forKey: testKey)
        XCTAssertEqual("234", value)
    }
    func test_set에서_값이_존재하지_않으면_값을_새로_설정한다() throws {
        // given
        // when
        try keychainManager.set(value: "123", forKey: testKey)
        // then
        let value = try keychainManager.get(forKey: testKey)
        XCTAssertEqual("123", value)
    }
    func test_get에서_값이_존재하지_않으면_keyNotFound에러를_반환한다() {
        // given
        // when
        // then
        XCTAssertThrowsError(try keychainManager.get(forKey: testKey)) { error in
            XCTAssert(error is KeychainError)
            XCTAssertEqual(error as! KeychainError, KeychainError.keyNotFound)
        }
    }
    func test_get에서_값이_존재하면_값을_반환한다() throws {
        // given
        // when
        try keychainManager.set(value: "123", forKey: testKey)
        // then
        let value = try keychainManager.get(forKey: testKey)
        XCTAssertEqual("123", value)
    }
}
