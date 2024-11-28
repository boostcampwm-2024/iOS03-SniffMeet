//
//  SaveInfoUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import Foundation

protocol SaveUserInfoUseCase {
    func execute(dog: UserInfo) throws
}

struct SaveUserInfoUseCaseImpl: SaveUserInfoUseCase {
    let localDataManager: DataStorable
    let imageManager: ImageManagable
    
    func execute(dog: UserInfo) throws {
        try localDataManager.storeData(data: dog, key: Environment.UserDefaultsKey.dogInfo)
        guard let imageData = dog.profileImage else { return }
        do {
            try imageManager.set(imageData: imageData, forKey: Environment.FileManagerKey.profileImage)
        } catch {
            SNMLogger.error("프로필 이미지 저장 실패: \(error.localizedDescription)")
        }
        
        try localDataManager.storeData(data: Array<UUID>() , key: Environment.UserDefaultsKey.mateList)
    }
}
