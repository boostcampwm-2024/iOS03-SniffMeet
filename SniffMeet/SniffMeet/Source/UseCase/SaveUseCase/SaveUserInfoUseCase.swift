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
        
        try localDataManager.storeData(data: [UUID(uuidString: "34cd1739-49af-4a19-802b-5df26ee32d5c"),
                                              UUID(uuidString: "d0b2d49c-bda9-49f7-9e95-86fe819c14a4"),
                                              UUID(uuidString: "75a2085e-3f25-4b3b-8f8c-454d3bba198b"),
                                              UUID(uuidString: "d5ef9020-e5af-45b3-b18d-5c03d7266c7d")],
                                       key: Environment.UserDefaultsKey.mateList)
    }
}
