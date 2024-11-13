//
//  UserDefaultsTests.swift
//  SNMPersistenceTests
//
//  Created by sole on 11/13/24.
//

import XCTest

final class UserDefaultsTests: XCTestCase {
    private var userDefaultsManager: UserDefaultsManager!
    private let userDefaults: UserDefaults = UserDefaults(suiteName: "SNMPersistenceTests.UserDefaultsManager")!

    override func setUp() {
        userDefaultsManager = UserDefaultsManager(
            userDefaults: userDefaults,
            jsonEncoder: JSONEncoder(),
            jsonDecoder: JSONDecoder()
        )
    }
    override func tearDown() {
        // 등록된 모든 값 reset
        userDefaults.removePersistentDomain(forName: "SNMPersistenceTests.UserDefaultsManager")
    }

    func test_set에서_Encodable한_타입을_저장할수_있다() throws {
        // given
        // when
        // then
        try userDefaultsManager.set(value: "hgd", forKey: "test")
        try userDefaultsManager.set(value: Data(), forKey: "test")
        try userDefaultsManager.set(value: 123, forKey: "test")
    }
    func test_get에서_Decodable한_타입을_읽어올수_있다() throws {
        // given
        try userDefaultsManager.set(value: "hgd", forKey: "test1")
        try userDefaultsManager.set(value: Data(), forKey: "test2")
        try userDefaultsManager.set(value: 123, forKey: "test3")
        // when
        let stringValue = try userDefaultsManager.get(forKey: "test1", type: String.self)
        let dataValue =  try userDefaultsManager.get(forKey: "test2", type: Data.self)
        let intValue = try userDefaultsManager.get(forKey: "test3", type: Int.self)
        // then
        XCTAssertEqual("hgd", stringValue)
        XCTAssertEqual(Data(), dataValue)
        XCTAssertEqual(123, intValue)
    }
    func test_get에서_지정한_디코딩_타입과_다르면_디코딩에러를_반환해야_한다() throws {
        // given
        try userDefaultsManager.set(value: "hgd", forKey: "test")
        // when
        // then
        XCTAssertThrowsError(try userDefaultsManager.get(forKey: "test", type: Int.self)) { error in
            XCTAssert(error is UserDefaultsError)
            XCTAssertEqual(error as! UserDefaultsError, UserDefaultsError.decodingError)
        }
    }
    func test_get에서_값이_존재할_때_값을_읽어올수_있다() throws {
        // given
        try userDefaultsManager.set(value: "hgd", forKey: "test")
        // when
        let value = try userDefaultsManager.get(forKey: "test", type: String.self)
        // then
        XCTAssertEqual(value, "hgd")
    }
    func test_get에서_값이_존재하지_않을때_notFound에러를_반환해야_한다() throws {
        // given
        // when
        // then
        XCTAssertThrowsError(try userDefaultsManager.get(forKey: "test", type: String.self)) { error in
            XCTAssert(error is UserDefaultsError)
            XCTAssertEqual(error as! UserDefaultsError, UserDefaultsError.notFound)
        }
    }
    func test_set에서_key에_값이_존재하지_않을때_값이_설정되어야_한다() throws {
        // given
        // when
        try userDefaultsManager.set(value: "hgd", forKey: "test")
        // then
        let value = try userDefaultsManager.get(forKey: "test", type: String.self)
        XCTAssertEqual("hgd", value)
    }
    func test_set에서_key에_값이_이미_존재할때_값이_덮어씌워져야_한다() throws {
        // given
        try userDefaultsManager.set(value: "hgd", forKey: "test")
        try userDefaultsManager.set(value: "sniffMeet", forKey: "test")
        // when
        let value = try userDefaultsManager.get(forKey: "test", type: String.self)
        // then
        XCTAssertEqual("sniffMeet", value)
    }
    func test_delete에서_key에_값이_존재하지_않을_때_noDeleteObject에러를_반환해야_한다() throws {
        XCTAssertThrowsError(try userDefaultsManager.delete(forKey: "test")) { error in
            XCTAssert(error is UserDefaultsError)
            XCTAssertEqual(error as! UserDefaultsError, UserDefaultsError.noDeleteObject)
        }
    }
    func test_delete에서_key에_값이_존재하면_값이_지워져야_한다() throws {
        // given
        try userDefaultsManager.set(value: "hgd", forKey: "test")
        // when
        try userDefaultsManager.delete(forKey: "test")
        // then
        let value = try? userDefaultsManager.get(forKey: "test", type: String.self)
        XCTAssertNil(value)
    }
}
