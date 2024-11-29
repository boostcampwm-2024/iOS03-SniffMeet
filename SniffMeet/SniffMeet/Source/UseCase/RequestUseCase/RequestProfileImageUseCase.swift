//
//  RequestProfileImageUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/24/24.
//

import Foundation

protocol RequestProfileImageUseCase {
    func execute() async -> Data?
}

struct RequestProfileImageUseCaseImpl: RequestProfileImageUseCase {
    func execute() async -> Data? {
        return nil
    }
}
