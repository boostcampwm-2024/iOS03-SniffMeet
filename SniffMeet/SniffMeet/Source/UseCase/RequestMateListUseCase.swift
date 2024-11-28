//
//  RequestMateListUseCase.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/24/24.
//

import Foundation

protocol RequestMateListUseCase {
    var remoteDatabaseManager: RemoteDatabaseManager { get }
    func execute() async -> [Mate]
}

struct RequestMateListUseCaseImpl: RequestMateListUseCase {
    var remoteDatabaseManager: (any RemoteDatabaseManager)
    
    func execute() async -> [Mate] {
        let decoder = JSONDecoder()

        do {
            let data = try await remoteDatabaseManager.fetchUserInfoFromMateList()
            let mateDTOList = try decoder.decode([UserInfoDTO].self, from: data)
            return mateDTOList.map {
                Mate(name: $0.dogName,
                     userID: $0.id,
                     keywords: $0.keywords,
                     profileImageURLString: $0.profileImageURL)
            }
        } catch {
            SNMLogger.error("RequestMateListUseCaseImpl: \(error.localizedDescription)")
            return []
        }
    }
}
