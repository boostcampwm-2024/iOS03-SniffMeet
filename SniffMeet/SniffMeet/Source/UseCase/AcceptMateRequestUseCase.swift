//
//  AcceptMateRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/27/24.
//
import Foundation

protocol RespondMateRequestUseCase {
    var localDataManager: DataStorable & DataLoadable { get }
    func execute(mateId: UUID, isAccepted: Bool)
}

struct RespondMateRequestUseCaseImpl: RespondMateRequestUseCase {
    var localDataManager: DataStorable & DataLoadable
    
    func execute(mateId: UUID, isAccepted: Bool) {
        if isAccepted {
            addMate(mateId: mateId)
        }
    }
    func addMate(mateId: UUID) {
        var mateList: [UUID]? = try? localDataManager.loadData(forKey: UserDefaultKey.mateList, type: [UUID].self)
        
        do {
            if var mateList {
                mateList.append(mateId)
                try localDataManager.storeData(data: mateList, key: UserDefaultKey.mateList)
            } else {
                try localDataManager.storeData(data: [mateId], key: UserDefaultKey.mateList)
            }
        } catch {
            SNMLogger.error("AcceptMateRequestUsecaseError: \(error.localizedDescription)")
        }
    }
}
