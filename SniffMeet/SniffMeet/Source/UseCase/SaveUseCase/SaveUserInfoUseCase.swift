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
        
        try localDataManager.storeData(data: [UUID(uuidString: "717765b9-2929-4a23-919b-3bb029f557fc"),
                                              UUID(uuidString: "46432436-4dd7-4915-a2e7-c714c45146d1"),
                                              UUID(uuidString: "1851b20f-57e4-4b37-b43c-b09b24393449"),
                                              UUID(uuidString: "f1be0742-7f05-4049-b883-099d017d2f4e")],
                                       key: Environment.UserDefaultsKey.mateList)
    }
}
