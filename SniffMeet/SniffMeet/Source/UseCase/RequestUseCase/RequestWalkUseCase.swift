//
//  RequestWalk.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import Foundation

protocol RequestWalkUseCase {
    func execute(walkNoti: WalkNotiDTO) async throws
}

struct RequestWalkUseCaseImpl: RequestWalkUseCase {
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let remoteDatabaseManager: RemoteDatabaseManager
    
    init(session: URLSession = URLSession.shared, remoteDatabaseManager: RemoteDatabaseManager) {
        self.session = session
        self.remoteDatabaseManager = remoteDatabaseManager
    }
    func execute(walkNoti: WalkNotiDTO) async throws {
        guard let requestData = try? encoder.encode(walkNoti) else { return }
        let request = try PushNotificationRequest.sendWalkRequest(data: requestData).urlRequest()
        let (_, response) = try await session.data(for: request)
        
        do {
            let requestData = WalkRequestInsertDTO(id: UUID(),
                                                   createdAt: walkNoti.createdAt,
                                                   sender: walkNoti.senderId,
                                                   receiver: walkNoti.receiverId,
                                                   message: walkNoti.message,
                                                   latitude: walkNoti.latitude,
                                                   longitude: walkNoti.longtitude,
                                                   state: .pending)
            let data = try encoder.encode(requestData)
            try await SupabaseDatabaseManager.shared.insertData(
                into: Environment.SupabaseTableName.walkRequest,
                with: data
            )
        } catch {
            SNMLogger.error("notifiaction list insert error: \(error.localizedDescription)")
        }
    
        if let response = response as? HTTPURLResponse {
            SNMLogger.log("RequestWalkUseCaseImpl: \(response)")
        }
    }
}
