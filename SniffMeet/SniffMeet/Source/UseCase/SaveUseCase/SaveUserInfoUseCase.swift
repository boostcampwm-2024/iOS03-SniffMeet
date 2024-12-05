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
            try imageManager.setImage(imageData: imageData,
                                      forKey: Environment.FileManagerKey.profileImage)
        } catch {
            SNMLogger.error("프로필 이미지 저장 실패: \(error.localizedDescription)")
        }
        try localDataManager.storeData(
            data: [
                UUID(uuidString: "f27c02f6-0110-4291-b866-a1ead0742755") ?? .init(),
                UUID(uuidString: "b79bc6b9-b776-4f5b-8f6c-48ba498b6e3a") ?? .init(),
                UUID(uuidString: "bda7ec28-1407-4871-93ea-c7835986726a") ?? .init(),
                UUID(uuidString: "a96ee934-03b9-43f3-b29b-53c3ba945363") ?? .init()
            ] , key: Environment.UserDefaultsKey.mateList)
    }
}
