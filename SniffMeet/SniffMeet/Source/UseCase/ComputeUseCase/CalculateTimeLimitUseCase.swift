//
//  CalculateTimeLimitUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/26/24.
//
import Foundation

protocol CalculateTimeLimitUseCase {
    func execute(requestTime: Date) -> Int
}

struct CalculateTimeLimitUseCaseImpl: CalculateTimeLimitUseCase {
    func execute(requestTime: Date) -> Int {
        let secondsDifference = requestTime.secondsDifferenceFromNow()
        let minuteSeconds = 60
        
        return minuteSeconds - secondsDifference > 0 ? minuteSeconds - secondsDifference : 0
    }
}
