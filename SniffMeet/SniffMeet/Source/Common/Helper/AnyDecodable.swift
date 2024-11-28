//
//  AnyDecodable.swift
//  SniffMeet
//
//  Created by sole on 11/28/24.
//

import Foundation

struct AnyDecodable {
    private let data: Data
    private let jsonDecoder: JSONDecoder

    init(
        data: Data,
        jsonDecoder: JSONDecoder = AnyDecodable.defaultDecoder
    ) {
        self.data = data
        self.jsonDecoder = jsonDecoder
    }

    func decode<T: Decodable>(type: T.Type) throws -> T {
        try jsonDecoder.decode(type, from: data)
    }
}

extension AnyDecodable {
    static let defaultDecoder: JSONDecoder = JSONDecoder()
}
