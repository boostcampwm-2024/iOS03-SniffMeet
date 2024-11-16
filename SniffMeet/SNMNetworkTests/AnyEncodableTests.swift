//
//  AnyEncodableTests.swift
//  SNMNetworkTests
//
//  Created by sole on 11/16/24.
//

import XCTest

final class AnyEncodableTests: XCTestCase {
    func test_encodable은_인코딩_되어야_한다() throws {
        let _ = try AnyEncodable(1).encode()
        let _ = try AnyEncodable(true).encode()
        let _ = try AnyEncodable("string").encode()
        let _ = try AnyEncodable([1, 2, 3]).encode()
    }
    func test_customEncoder를_주입했을때_인코더_설정대로_인코딩되어야_한다() throws {
        let cusomJSONEncoder = JSONEncoder()
        cusomJSONEncoder.keyEncodingStrategy = .convertToSnakeCase
        let encodable = AnyEncodable(1, jsonEncoder: cusomJSONEncoder)
        let _ = try encodable.encode()
    }
}
