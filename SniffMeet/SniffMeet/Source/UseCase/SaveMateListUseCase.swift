//
//  SaveMateListUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/28/24.
//

protocol SaveMateListUseCase {
    func execute(mates: [UserInfoDTO]) throws
}

struct SaveMateListUseCaseImpl: SaveMateListUseCase {
    let localDataManager: DataStorable

    func execute(mates: [UserInfoDTO]) throws {
        do {
            try localDataManager.storeData(data: mates, key: Environment.UserDefaultsKey.mateList)
        } catch {
            SNMLogger.error("메이트목록 저장 실패: \(error.localizedDescription)")
        }
    }
}
