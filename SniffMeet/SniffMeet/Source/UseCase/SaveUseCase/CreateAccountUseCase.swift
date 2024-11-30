//
//  StoreUserInfoRemoteUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/26/24.
//

import Foundation

protocol CreateAccountUseCase {
    func execute(info: UserInfoDTO) async
}

struct CreateAccountUseCaseImpl: CreateAccountUseCase {
    // RLS 정책은 ID 기반으로 인증이 됩니다. 따라서 info에 id 정보가 필요합니다.
    func execute(info: UserInfoDTO) async {
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(info)
            try await SupabaseDatabaseManager.shared.insertData(
                into: Environment.SupabaseTableName.userInfo,
                with: userData
            )
            
        } catch {
            SNMLogger.error("\(error.localizedDescription)")
        }
        do {
            let mateListData = try encoder.encode(MateListInsertDTO(id: info.id))
            try await SupabaseDatabaseManager.shared.insertData(
                into: Environment.SupabaseTableName.matelist,
                with: mateListData
            )
        } catch {
            SNMLogger.error("mate list insert error: \(error.localizedDescription)")
        }
        do {
            let notiListData = try encoder.encode(WalkNotiListInsertDTO(id: info.id))
            try await SupabaseDatabaseManager.shared.insertData(
                into: Environment.SupabaseTableName.notificationList,
                with: notiListData
            )
        } catch {
            SNMLogger.error("notifiaction list insert error: \(error.localizedDescription)")
        }
    }
}
