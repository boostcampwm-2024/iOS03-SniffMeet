//
//  FetchRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation

protocol FetchRequestUseCase {
    func execute(requestNum: Int) throws -> WalkRequest 
}


struct FetchRequestUseCaseImpl: FetchRequestUseCase {
    func execute(requestNum: Int) throws -> WalkRequest {
        // network를 이용해서 서버에서 request 정보를 가져오는 코드
        return WalkRequest(dog: Dog.example, address: Address.example , message: "안녕하쇼잉")
    }
}
