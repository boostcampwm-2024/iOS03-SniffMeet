//
//  RespondWalkRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation

protocol RespondWalkRequestUseCase {
    func execute(walkNotiId: UUID, isAccepted: Bool) throws
}

struct RespondWalkRequestUseCaseImpl: RespondWalkRequestUseCase {
    func execute(walkNotiId: UUID, isAccepted: Bool) throws {
        if isAccepted {
            // 서버에 수락 응답을 보낸다.
        } else {
            // 서버에 거절 응답을 보낸다.
        }
    }
}
