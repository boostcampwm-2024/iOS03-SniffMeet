//
//  RequestConvertible.swift
//  HGDNetwork
//
//  Created by 윤지성 on 11/7/24.
//

import Foundation

public protocol SNMRequestConvertible {
    var endpoint: Endpoint { get }
    var requestType: SNMRequestType { get }
}

public extension SNMRequestConvertible {
    func urlRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: endpoint.absoluteURL)

        switch requestType {
        case .plain:
            break

        case .header(let header):
            header.forEach {
                urlRequest.setValue($0, forHTTPHeaderField: $1)
            }

        case .jsonEncodableBody(let body):
            // HTTP Method가 GET이면서 body가 존재하면 invalid로 처리
            guard !(endpoint.method == .get)
            else { throw SNMNetworkError.invalidRequest(request: self) }
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let jsonEncoder: JSONEncoder = JSONEncoder()
                let encodedData = try jsonEncoder.encode(body)
                urlRequest.httpBody = encodedData
            } catch {
                throw SNMNetworkError.encodingError(with: body)
            }
        }

        return urlRequest
    }
}

public enum SNMRequestType {
    case plain
    case header(with: [String: String])
    /// Content-Type: application/json이 자동으로 적용됩니다.
    case jsonEncodableBody(with: Encodable)
    // TODO: MultipartFormData
}
