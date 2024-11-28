//
//  ConverToRequestAPSUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/28/24.
//

import Foundation

protocol ConvertToRequestAPSUseCase {
    func execute(userInfo: [AnyHashable: Any]) -> RequestAPS?
}

struct ConverToRequestAPSUseCaseImpl: ConvertToRequestAPSUseCase {
    private let jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = AnyDecodable.defaultDecoder) {
        self.jsonDecoder = jsonDecoder
    }

    func execute(userInfo: [AnyHashable : Any]) -> RequestAPS? {
        try? AnyJSONSerializable(
            value: userInfo,
            jsonDecoder: jsonDecoder
        )?.decode(type: RequestAPS.self)
    }
}
