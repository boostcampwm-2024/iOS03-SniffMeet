//
//  MockURLRequest.swift
//  SniffMeet
//
//  Created by sole on 11/16/24.
//

import Foundation

enum MockRequest: SNMRequestConvertible {
    case successFetch
    case successPost
    case invaildURL
    case getMethodWithBody

    var endpoint: Endpoint {
        let baseURL: URL = URL(string: "https://example.com")!
        switch self {
        case .successFetch:
            return Endpoint(baseURL: baseURL, path: "", method: .get)
        case .successPost:
            return Endpoint(baseURL: baseURL, path: "", method: .post)
        case .invaildURL:
            return Endpoint(baseURL: baseURL, path: "|||", method: .get)
        case .getMethodWithBody:
            return Endpoint(baseURL: baseURL, path: "", method: .get)
        }
    }

    var requestType: SNMRequestType {
        switch self {
        case .successFetch: .plain
        case .successPost: .compositeJSONEncodable(header: [:], body: Data())
        case .invaildURL: .plain
        case .getMethodWithBody: .compositePlain(header: [:], body: Data())
        }
    }
}
