//
//  EndpointTests.swift
//  SNMNetworkTests
//
//  Created by sole on 11/16/24.
//

import XCTest

final class EndpointTests: XCTestCase {
    func test_baseURL에_path가_이미_포함되어있으면_path를_합친다() {
        // given
        let url: URL = URL(string: "https://example.com/path")!
        // when
        let endpoint = Endpoint(baseURL: url, path: "login", method: .get)
        // then
        XCTAssertEqual(endpoint.absoluteURL, URL(string: "https://example.com/path/login")!)
    }
    func test_baseURL끝에_슬래시가_포함되어있고_path앞에_슬래시가_있으면_하나의_슬래시로_합친다() {
        // given
        let url: URL = URL(string: "https://example.com/path/")!
        // when
        let endpoint = Endpoint(baseURL: url, path: "login", method: .get)
        // then
        XCTAssertEqual(endpoint.absoluteURL, URL(string: "https://example.com/path/login")!)
    }
    func test_path끝에_슬래시가_포함되어_있으면_absoluteURL도_슬래시를_포함한다() {
        // given
        let url: URL = URL(string: "https://example.com/path")!
        // when
        let endpoint = Endpoint(baseURL: url, path: "login/", method: .get)
        // then
        XCTAssertEqual(endpoint.absoluteURL, URL(string: "https://example.com/path/login/")!)
    }
    func test_query를_추가할_때_queryItems가_추가된다() {
        // given
        let url: URL = URL(string: "https://example.com/path")!
        var endpoint = Endpoint(baseURL: url, path: "login", method: .get)
        // when
        endpoint.query = ["key": "value"]
        // then
        XCTAssertEqual(endpoint.absoluteURL.query, "key=value")
    }
    func test_query를_여러개_추가할_때_queryItems가_함께_추가된다() {
        // given
        let url: URL = URL(string: "https://example.com/path")!
        var endpoint = Endpoint(baseURL: url, path: "login", method: .get)
        // when
        endpoint.query = ["key": "value", "key2": "value2"]
        // then
        endpoint.absoluteURL.absoluteString.components(separatedBy: "?")[1]
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .forEach { queryItem in
                XCTAssertEqual(endpoint.query?[queryItem[0]], queryItem[1])
            }
    }
    func test_path가_빈문자열이면_슬래시만_추가된다() {
        // given
        let url: URL = URL(string: "https://example.com/path")!
        // when
        let endpoint = Endpoint(baseURL: url, path: "", method: .get)
        // then
        XCTAssertEqual(endpoint.absoluteURL, URL(string: "https://example.com/path/")!)
    }
}
