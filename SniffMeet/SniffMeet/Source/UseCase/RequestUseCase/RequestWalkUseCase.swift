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
    
    init(session: URLSession = URLSession.shared ) {
        self.session = session
    }
    func execute(walkNoti: WalkNotiDTO) async throws {
        guard let requestData = try? encoder.encode(walkNoti) else { return }
        let request = try PushNotificationRequest.sendWalkRequest(data: requestData).urlRequest()
        let (_, response) = try await session.data(for: request)
    
        if let response = response as? HTTPURLResponse {
            SNMLogger.log("RequestWalkUseCaseImpl: \(response)")
        }
    }
}
