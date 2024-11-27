//
//  AcceptMateRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/27/24.
//
import Foundation

protocol AcceptMateRequestUseCase {
    var localDataManager: DataStorable & DataLoadable { get }
    func execute(mateId: UUID)
}

struct AcceptMateRequestUseCaseImpl: AcceptMateRequestUseCase {
    var localDataManager: DataStorable & DataLoadable
    
    func execute(mateId: UUID) {
        do {
            var mateList: [UUID] = try localDataManager.loadData(forKey: UserDefaultKey.mateList, type: [UUID].self)
            mateList.append(mateId)
            try localDataManager.storeData(data: mateList, key: UserDefaultKey.mateList)
        } catch {
            SNMLogger.error("AcceptMateRequestUsecaseError: \(error.localizedDescription)")
        }
    }
}
