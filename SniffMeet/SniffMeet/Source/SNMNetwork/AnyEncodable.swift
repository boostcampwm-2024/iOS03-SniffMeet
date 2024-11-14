//
//  AnyEncodable.swift
//  SniffMeet
//
//  Created by sole on 11/14/24.
//

import Foundation

struct AnyEncodable {
    private let jsonEncoder: JSONEncoder
    private let value: any Encodable
    
    init(_ value: any Encodable, jsonEncoder: JSONEncoder = AnyEncodable.defaultJSONEncoder) {
        self.value = value
        self.jsonEncoder = jsonEncoder
    }
    
    func encode() throws -> Data {
        try jsonEncoder.encode(value)
    }
}

extension AnyEncodable {
    static let defaultJSONEncoder: JSONEncoder = JSONEncoder()
}
