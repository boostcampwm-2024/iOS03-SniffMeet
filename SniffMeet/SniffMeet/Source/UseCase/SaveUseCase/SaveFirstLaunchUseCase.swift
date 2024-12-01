//
//  SaveFirstLaunchUseCase.swift
//  SniffMeet
//
//  Created by sole on 12/1/24.
//

protocol SaveFirstLaunchUseCase {
    func execute() throws
}

struct SaveFirstLaunchUseCaseImpl: SaveFirstLaunchUseCase {
    private let userDefaultsManager: any UserDefaultsManagable

    init(userDefaultsManager: any UserDefaultsManagable) {
        self.userDefaultsManager = userDefaultsManager
    }

    func execute() throws {
        try userDefaultsManager.set(
            value: true,
            forKey: Environment.UserDefaultsKey.isFirstLaunch
        )
    }
}
