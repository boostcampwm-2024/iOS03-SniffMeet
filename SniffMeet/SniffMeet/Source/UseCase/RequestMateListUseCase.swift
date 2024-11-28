//
//  RequestMateListUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/24/24.
//

import Foundation

protocol RequestMateListUseCase {
    func execute() async -> [Mate]
}

struct RequestMateListUseCaseImpl: RequestMateListUseCase {
    func execute() async -> [Mate] {
        return [Mate(name: "강아", userID: UUID(), keywords: [.energetic], profileImageURLString: "")]
    }
}
