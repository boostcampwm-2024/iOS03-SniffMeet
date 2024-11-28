//
//  StoreUserInfoRemoteUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/26/24.
//

import Foundation

protocol SaveUserInfoRemoteUseCase {
    func execute(info: UserInfoDTO) async
}

struct SaveUserInfoRemoteUseCaseImpl: SaveUserInfoRemoteUseCase {
    // RLS 정책은 ID 기반으로 인증이 됩니다. 따라서 info에 id 정보가 필요합니다.
    func execute(info: UserInfoDTO) async {
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(info)
            let mateListData = try encoder.encode(MateListDTO(id: info.id, mates: []))
            try await SupabaseDatabaseManager.shared.insertData(
                into: Environment.SupabaseTableName.userInfo,
                with: userData
            )
            try await SupabaseDatabaseManager.shared.insertData(
                into: Environment.SupabaseTableName.matelist,
                with: mateListData
            )
        } catch {
            SNMLogger.error("\(error.localizedDescription)")
        }
    }
}
