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


final class StoreDogInfoUseCaseImpl: StoreDogInfoUseCase {
    let localDataManager: DataStorable
    
    init(localDataManager: DataStorable) {
        self.localDataManager = localDataManager
    }
    
    func execute(dog: Dog) throws {
        try localDataManager.storeData(data: dog)
    }
}
