//
//  RespondWalkRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation

protocol RespondWalkRequestUseCase {
    func accept(to requestNum: Int) throws
    func decline(to requestNum: Int) throws
}

struct RespondWalkRequestUseCaseImpl: RespondWalkRequestUseCase {
    func accept(to requestNum: Int) throws{
         
    }
    func decline(to requestNum: Int) throws{
        
    }
}
