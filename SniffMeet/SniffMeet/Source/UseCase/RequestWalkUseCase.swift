//
//  RequestWalk.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import Foundation

protocol RequestWalkUseCase {
    func execute(dog: UserInfo) throws
}


struct RequestWalkUseCaseImpl: RequestWalkUseCase {
    func execute(dog: UserInfo) throws {
    }
}
