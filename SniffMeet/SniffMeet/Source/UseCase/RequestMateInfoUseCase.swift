//
//  RequestMateInfoUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/28/24.
//

import Foundation

// RequestUserInfoUseCase와 통합이 가능하다고 예상됩니다.
protocol RequestMateInfoUseCase {
    func execute(mateId: UUID) async -> UserInfoDTO?
}

struct RequestMateInfoUsecaseImpl: RequestMateInfoUseCase {
    func execute(mateId: UUID) async -> UserInfoDTO? {
        do {
            let mateInfoData = try await SupabaseDatabaseManager.shared.fetchData(
                from: "user_info",
                query: ["id": "eq.\(mateId.uuidString)"]
            )
            let mateInfo = try JSONDecoder().decode(UserInfoDTO.self, from: mateInfoData)
            return mateInfo
        } catch {
            return nil
        }
    }
}
