//
//  RequestNotiListUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/30/24.
//
import Foundation

protocol RequestNotiListUseCase {
    var remoteManager: (any RemoteDatabaseManager) { get }
    func execute() async -> [WalkNoti]
}

struct RequestNotiListUseCaseImpl: RequestNotiListUseCase {
    var remoteManager: (any RemoteDatabaseManager)
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init(remoteManager: any RemoteDatabaseManager) {
        self.remoteManager = remoteManager
        decoder = JSONDecoder()
        encoder = JSONEncoder()
    }
    
    func execute() async -> [WalkNoti] {
        let tableName = Environment.SupabaseTableName.notificationListFunction

        do {
            guard let userID = SessionManager.shared.session?.user?.userID else { return [] }
            
            let requestData = try encoder.encode(WalkNotiListRequestDTO(userId: userID))
            let data = try await remoteManager.fetchList(into: tableName, with: requestData)
            let walkDTOList = try decoder.decode([WalkNotiDTO].self, from: data)
            
            return walkDTOList.map { $0.toEntity() }
        } catch {
            SNMLogger.error("RequestNotiListUseCaseImpl: \(error.localizedDescription)")
            return []
        }
    }
}
