//
//  AnyJSONSerializable.swift
//  SniffMeet
//
//  Created by sole on 11/27/24.
//

import Foundation

struct AnyJSONSerializable {
    private let value: Any
    private let jsonDecoder: JSONDecoder

    init?(
        value: Any,
        jsonDecoder: JSONDecoder = AnyDecodable.defaultDecoder
    ) {
        guard JSONSerialization.isValidJSONObject(value) else { return nil }
        self.value = value
        self.jsonDecoder = jsonDecoder
    }

    func decode<T: Decodable>(type: T.Type) throws -> T {
        let serializedData = try JSONSerialization.data(withJSONObject: value)
        let decodedData = try AnyDecodable(data: serializedData).decode(type: T.self)
        return decodedData
    }
}
