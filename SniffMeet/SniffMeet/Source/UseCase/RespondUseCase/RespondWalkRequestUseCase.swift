//
//  RespondWalkRequestUseCase.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation

protocol RespondWalkRequestUseCase {
    func execute(walkNoti: WalkNotiDTO, isAccepted: Bool) async throws
}

struct RespondWalkRequestUseCaseImpl: RespondWalkRequestUseCase {
    private let session: URLSession
    private let encoder = JSONEncoder()
    
    init(session: URLSession = URLSession.shared ) {
        self.session = session
    }
    
    func execute(walkNoti: WalkNotiDTO, isAccepted: Bool) async throws {
        guard let requestData = try? encoder.encode(walkNoti) else { return }
        let request = try PushNotificationRequest.sendWalkRespond(data: requestData).urlRequest()
        let (_, response) = try await session.data(for: request)
    
        if let response = response as? HTTPURLResponse {
            print(response)
        }
    }
}
