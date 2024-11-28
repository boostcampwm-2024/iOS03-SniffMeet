//
//  RequestUserInfoRemoteUseCase.swift
//  SniffMeet
//
//  Created by 배현진 on 11/27/24.
//

import Foundation

protocol RequestUserInfoRemoteUseCase {
    func execute() async throws -> [UserInfo]
}

struct RequestUserInfoRemoteUseCaseImpl: RequestUserInfoRemoteUseCase {
    func execute() async throws -> [UserInfo] {
        guard let userID = SessionManager.shared.session?.user?.userID else {
            throw SupabaseError.sessionNotExist
        }
        let data = try await SupabaseDatabaseManager.shared.fetchDataWithID(from: "user_info",
                                                                            with: userID)
        let decoder = JSONDecoder()
        let info = try decoder.decode([UserInfo].self, from: data)
        return info
    }
}
