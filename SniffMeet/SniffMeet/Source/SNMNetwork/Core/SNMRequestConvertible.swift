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
    /// Request가 유효한지 판단합니다.
    var isValid: Bool {
        switch requestType {
        // method가 get이고 body가 있는 requestType을 정의하면 invalid로 판단합니다.
        case .compositeJSONEncodable where endpoint.method == .get,
                .compositePlain where endpoint.method == .get,
                .jsonEncodableBody where endpoint.method == .get,
                .multipartFormData where endpoint.method == .get:
            false
        default:
            true
        }
    }

    func urlRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: endpoint.absoluteURL)
        urlRequest.httpMethod = endpoint.method.rawValue
        guard isValid
        else {
            throw SNMNetworkError.invalidRequest(request: self)
        }

        switch requestType {
        case .plain:
            break

        case .header(let header):
            urlRequest.append(header: header)

        case .jsonEncodableBody(let body):
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            try urlRequest.append(body: body)

        case .compositePlain(let header, let body):
            urlRequest.append(header: header)
            urlRequest.httpBody = body

        case .compositeJSONEncodable(let header, let body):
            var header = header
            header["Content-Type"] = "application/json"
            urlRequest.append(header: header)
            try urlRequest.append(body: body)

        case .multipartFormData(let header, let multipartFormData):
            var header = header
            header["Content-Type"] = "multipart/form-data; boundary=\(multipartFormData.boundary)"
            urlRequest.append(header: header)
            urlRequest.httpBody = multipartFormData.compositeBody
        }

        return urlRequest
    }
}
