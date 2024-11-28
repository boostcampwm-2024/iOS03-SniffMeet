//
//  LoadInfoUseCase.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

protocol LoadUserInfoUseCase {
    func execute() throws -> UserInfo
}

struct LoadUserInfoUseCaseImpl: LoadUserInfoUseCase {
    private let dataLoadable: (any DataLoadable)

    init(dataLoadable: any DataLoadable) {
        self.dataLoadable = dataLoadable
    }

    func execute() throws -> UserInfo {
        try dataLoadable.loadData(forKey: "dogInfo", type: UserInfo.self)
    }
}
