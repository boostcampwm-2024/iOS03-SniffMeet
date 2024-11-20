//
//  URLRequest + append.swift
//  SniffMeet
//
//  Created by sole on 11/16/24.
//

import Foundation

extension URLRequest {
    mutating func append(header: [String: String]) {
        header.forEach {
            self.setValue($1, forHTTPHeaderField: $0)
        }
    }
    mutating func append(body: any Encodable) throws {
        do {
            let anyEncodableBody = AnyEncodable(body)
            let encodedData = try anyEncodableBody.encode()
            self.httpBody = encodedData
        } catch {
            throw SNMNetworkError.encodingError(with: body)
        }
    }
}
