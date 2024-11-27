//
//  StoreUserInfoRemoteUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/26/24.
//

import Foundation

protocol SaveUserInfoRemoteUseCase {
    func execute(info: UserInfo) async
}

struct SaveUserInfoRemoteUseCaseImpl: SaveUserInfoRemoteUseCase {
    // RLS 정책은 ID 기반으로 인증이 됩니다. 따라서 info에 id 정보가 필요합니다.
    func execute(info: UserInfo) async {
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(info)
            try await SupabaseDatabaseManager.shared.insertData(
                into: "user_info",
                with: userData
            )
        } catch {
            SNMLogger.error("\(error.localizedDescription)")
        }
    }
}
