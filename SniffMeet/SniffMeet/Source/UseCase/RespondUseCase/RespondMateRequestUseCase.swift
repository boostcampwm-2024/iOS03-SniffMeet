//
//  AcceptMateRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/27/24.
//
import Foundation

protocol RespondMateRequestUseCase {
    var localDataManager: DataStorable & DataLoadable { get }
    func execute(mateId: UUID, isAccepted: Bool) async
}

struct RespondMateRequestUseCaseImpl: RespondMateRequestUseCase {
    var localDataManager: DataStorable & DataLoadable
    var remoteDataManger: RemoteDatabaseManager
    
    func execute(mateId: UUID, isAccepted: Bool) async {
        if isAccepted {
            await addMate(mateId: mateId)
        }
    }
    func addMate(mateId: UUID) async {
        var mateList: [UUID] =  []
        let encoder = JSONEncoder()
        do {
            mateList = try localDataManager.loadData(forKey: Environment.UserDefaultsKey.mateList, type: [UUID].self)
        } catch {
            mateList = []
        }
        do {
            guard let userID = SessionManager.shared.session?.user?.userID else {
                throw SupabaseError.sessionNotExist
            }
            
            mateList.append(mateId)
            mateList = Array(Set(mateList))
            let mateListData = try encoder.encode(MateListDTO(mates: mateList))
            try await remoteDataManger.updateData(into: Environment.SupabaseTableName.matelist,
                                                  with: mateListData)
            
            try localDataManager.storeData(data:mateList, key: Environment.UserDefaultsKey.mateList)
        } catch {
            SNMLogger.error("AcceptMateRequestUsecaseError: \(error.localizedDescription)")
        }
    }
}
