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
    private let imageManageable: (any ImageManagable)

    init(dataLoadable: any DataLoadable, imageManageable: any ImageManagable) {
        self.dataLoadable = dataLoadable
        self.imageManageable = imageManageable
    }

    func execute() throws -> UserInfo {
        var userInfo = try dataLoadable.loadData(forKey: Environment.UserDefaultsKey.dogInfo,
                                                 type: UserInfo.self)
        userInfo.profileImage = try imageManageable.get(forKey: Environment.FileManagerKey.profileImage)
        return userInfo
    }
}
