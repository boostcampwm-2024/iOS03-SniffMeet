//
//  ConvertToWalkAPSUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/28/24.
//

import Foundation

protocol ConvertToWalkAPSUseCase {
    func execute(walkAPSUserInfo: [AnyHashable: Any]) -> WalkAPSDTO?
}

struct ConvertToWalkAPSUseCaseImpl: ConvertToWalkAPSUseCase {
    private let jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = AnyDecodable.defaultDecoder) {
        self.jsonDecoder = jsonDecoder
    }

    func execute(walkAPSUserInfo: [AnyHashable : Any]) -> WalkAPSDTO? {
        try? AnyJSONSerializable(
            value: walkAPSUserInfo,
            jsonDecoder: jsonDecoder
        )?.decode(type: WalkAPSDTO.self)
    }
}
