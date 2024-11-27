//
//  SaveInfoUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import Foundation

protocol StoreDogInfoUseCase {
    func execute(dog: Dog) throws
}

struct StoreDogInfoUseCaseImpl: StoreDogInfoUseCase {
    let localDataManager: DataStorable
    
    func execute(dog: Dog) throws {
        try localDataManager.storeData(data: dog, key: UserDefaultKey.dogInfo)
    }
}
