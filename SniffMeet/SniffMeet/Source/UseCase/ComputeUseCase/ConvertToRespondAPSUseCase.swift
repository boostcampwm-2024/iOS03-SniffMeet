//
//  ConvertToRespondAPSUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/28/24.
//

import Foundation

protocol ConvertToRespondAPSUseCase {
    func execute(userInfo: [AnyHashable: Any]) -> RespondAPS?
}

struct ConvertToRespondAPSUseCaseImpl: ConvertToRespondAPSUseCase {
    private let jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = AnyDecodable.defaultDecoder) {
        self.jsonDecoder = jsonDecoder
    }

    func execute(userInfo: [AnyHashable: Any]) -> RespondAPS? {
        try? AnyJSONSerializable(
            value: userInfo,
            jsonDecoder: jsonDecoder
        )?.decode(type: RespondAPS.self)
    }
}
