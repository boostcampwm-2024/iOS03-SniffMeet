//
//  RequestMateListUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/24/24.
//

import Foundation

protocol RequestMateListUseCase {
    var remoteDatabaseManager: RemoteDatabaseManager { get }
    func execute() async -> [Mate]
}

struct RequestMateListUseCaseImpl: RequestMateListUseCase {
    var remoteDatabaseManager: (any RemoteDatabaseManager)
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    
    init(remoteDatabaseManager: any RemoteDatabaseManager) {
        self.remoteDatabaseManager = remoteDatabaseManager
        decoder = JSONDecoder()
        encoder = JSONEncoder()
    }
    
    func execute() async -> [Mate] {
        do {
            let tableName = Environment.SupabaseTableName.matelistFunction
            guard let userID = SessionManager.shared.session?.user?.userID else { return [] }
            let requestData = try encoder.encode(MateListRequestDTO(userId: userID))
            
            let data = try await remoteDatabaseManager.fetchList(into: tableName,with: requestData)
            let mateDTOList = try decoder.decode([UserInfoDTO].self, from: data)
            return mateDTOList.map {
                Mate(name: $0.dogName,
                     userID: $0.id,
                     keywords: $0.keywords,
                     profileImageURLString: $0.profileImageURL)
            }
        } catch {
            SNMLogger.error("RequestMateListUseCaseImpl: \(error.localizedDescription)")
            return []
        }
    }
}
