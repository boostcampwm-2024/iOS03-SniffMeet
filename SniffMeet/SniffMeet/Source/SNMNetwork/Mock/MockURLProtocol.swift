//
//  MockURLProtocol.swift
//  SniffMeet
//
//  Created by sole on 11/16/24.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(
                self,
                didFailWithError: NSError(domain: "응답 핸들러를 정의하지 않았습니다.", code: -1)
            )
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    // TODO: 네트워크 작업 취소 테스트 필요
    override func stopLoading() {}
}

extension MockURLProtocol {
    /// 테스트에서 사용할 응답을 정의합니다.
    static var requestHandler: ((URLRequest) throws -> (URLResponse, Data))?

    override static func canInit(with request: URLRequest) -> Bool {
        true
    }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
}
