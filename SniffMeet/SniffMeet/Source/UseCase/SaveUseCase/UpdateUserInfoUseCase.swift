//
//  UpdateUserInfoUseCase.swift
//  SniffMeet
//
//  Created by 배현진 on 12/1/24.
//

import Foundation

protocol UpdateUserInfoUseCase {
    func execute(info: UserInfoDTO) async
}

struct UpdateUserInfoUseCaseImpl: UpdateUserInfoUseCase {
    func execute(info: UserInfoDTO) async {
        do {
            let userData = try JSONEncoder().encode(info)
            try await SupabaseDatabaseManager.shared.updateData(
                into: Environment.SupabaseTableName.userInfo,
                with: userData
            )
        } catch {
            SNMLogger.error("\(error.localizedDescription)")
        }
    }
}
