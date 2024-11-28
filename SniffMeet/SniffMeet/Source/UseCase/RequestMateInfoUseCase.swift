//
//  RequestMateInfoUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/28/24.
//

import Foundation

// RequestUserInfoUseCase와 통합이 가능하다고 예상됩니다.
protocol RequestMateInfoUseCase {
    func execute() async -> UserInfoDTO?
}

struct RequestMateInfoUsecaseImpl: RequestMateInfoUseCase {
    let mateID: UUID
    func execute() async -> UserInfoDTO? {
        do {
            let mateInfoData = try await SupabaseDatabaseManager.shared.fetchData(
                from: "user_info",
                query: ["id": "eq.\(mateID.uuidString)"]
            )
            let mateInfo = try JSONDecoder().decode(UserInfoDTO.self, from: mateInfoData)
            return mateInfo
        } catch {
            return nil
        }
    }
}
