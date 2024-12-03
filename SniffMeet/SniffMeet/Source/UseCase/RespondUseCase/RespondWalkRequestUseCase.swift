//
//  RespondWalkRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation

protocol RespondWalkRequestUseCase {
    func execute(walkNoti: WalkNotiDTO) async throws
}

struct RespondWalkRequestUseCaseImpl: RespondWalkRequestUseCase {
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let remoteDatabaseManager: RemoteDatabaseManager
    
    init(session: URLSession = URLSession.shared, remoteDatabaseManager: RemoteDatabaseManager) {
        self.session = session
        self.remoteDatabaseManager = remoteDatabaseManager
    }
    
    func execute(walkNoti: WalkNotiDTO) async throws {
        guard let requestData = try? encoder.encode(walkNoti) else { return }
        let request = try PushNotificationRequest.sendWalkRespond(data: requestData).urlRequest()
        let (_, response) = try await session.data(for: request)
    
        if let response = response as? HTTPURLResponse {
            SNMLogger.log("\(response)")
        }
        
        // MARK: - walk-request 테이블 업데이트
        var tableData: WalkRequestUpdateDTO?
        switch walkNoti.category {
        case .walkAccepted:
            tableData = WalkRequestUpdateDTO(state: .accepted)
        case .walkDeclined:
            tableData = WalkRequestUpdateDTO(state: .declined)
        default:
            break
        }
        guard let tableData else { return }
        let data = try JSONEncoder().encode(tableData)
        Task {
            try await remoteDatabaseManager.updateData(
                into: Environment.SupabaseTableName.walkRequest,
                at: walkNoti.id,
                with: data)
        }
    }
}
