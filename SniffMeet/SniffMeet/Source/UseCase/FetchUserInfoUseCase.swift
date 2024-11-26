//
//  FetchRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation

protocol FetchUserInfoUseCase {
    func execute(userId: UUID) throws -> Dog
}


struct FetchUserInfoUsecaseImpl: FetchUserInfoUseCase {
    func execute(userId: UUID) throws -> Dog {
        // network를 이용해서 서버에서 request 정보를 가져오는 코드
        return Dog.example
    }
}
