//
//  FetchRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation

protocol RequestUserInfoUseCase {
    func execute(userId: UUID) throws -> UserInfo
}


struct RequestUserInfoUsecaseImpl: RequestUserInfoUseCase {
    func execute(userId: UUID) throws -> UserInfo {
        // network를 이용해서 서버에서 request 정보를 가져오는 코드
        return UserInfo.example
    }
}
