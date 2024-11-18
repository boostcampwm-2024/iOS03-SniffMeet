//
//  SNMNetworkTests.swift
//  SNMNetworkTests
//
//  Created by sole on 11/16/24.
//

import XCTest

final class SNMNetworkTests: XCTestCase {
    private var networkProvider: SNMNetworkProvider!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        networkProvider = SNMNetworkProvider(session: session)
    }

    func test_statusCode가_200번대이면_response를_반환한다() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = Data("{\"key\":\"value\"}".utf8)
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        let mockRequest = MockRequest.successFetch
        let response = try await networkProvider.request(with: mockRequest)

        XCTAssertEqual(response.statusCode.rawValue, 200)
        XCTAssertEqual(response.data, Data("{\"key\":\"value\"}".utf8))
    }
    func test_404에러가_반환되면_failedStatusCode_에러를_반환한다() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = Data("Not Found".utf8)
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        let mockRequest = MockRequest.successFetch
        do {
            _ = try await networkProvider.request(with: mockRequest)
        } catch SNMNetworkError.failedStatusCode(let reason) {
            XCTAssertTrue(reason == .notFound)
        } catch {
            XCTFail("failedStatusCode가 아닙니다. \(error.localizedDescription)")
        }
    }
    func test_httpStatusCode가_아니면_invaildResponse_에러를_반환한다() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = Data("Not Found".utf8)
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: -1,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        let mockRequest = MockRequest.successFetch
        do {
            _ = try await networkProvider.request(with: mockRequest)
        } catch SNMNetworkError.invalidResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail("failedStatusCode가 아닙니다. \(error.localizedDescription)")
        }
    }
    func test_서버응답이_httpResponse가_아니면_invaildResponseError를_반환한다() async throws {
        MockURLProtocol.requestHandler = { request in
            let data = Data("{\"key\":\"value\"}".utf8)
            let response = URLResponse(
                url: request.url!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
            return (response, data)
        }
        let mockRequest = MockRequest.invaildURL
        do {
            let _ = try await networkProvider.request(with: mockRequest)
        } catch SNMNetworkError.invalidResponse {
            XCTAssertTrue(true)
        } catch {
            XCTFail("invaildResponseError가 아닙니다. \(error.localizedDescription)")
        }
    }
    func test_get이면서_body를_가지면_invaildRequestError를_반환한다() async throws {
        // given
        MockURLProtocol.requestHandler = { request in
            let data = Data("Success".utf8)
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        // when
        let mockRequest = MockRequest.getMethodWithBody
        // then
        do {
            let _ = try await networkProvider.request(with: mockRequest)
        } catch SNMNetworkError.invalidRequest {
            XCTAssertTrue(true)
        } catch {
            XCTFail("invalidRequestError가 아닙니다. \(error.localizedDescription)")
        }
    }
}
