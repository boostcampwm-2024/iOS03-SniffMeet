//
//  HomeInteractor.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

protocol HomeInteractable: AnyObject {
    var presenter: (any HomePresentable)? { get }
    func loadInfo() throws -> UserInfo
    func saveDeviceToken()
}

final class HomeInteractor: HomeInteractable {
    weak var presenter: (any HomePresentable)?
    private let loadUserInfoUseCase: any LoadUserInfoUseCase
    private let checkFirstLaunchUseCase: any CheckFirstLaunchUseCase
    private let saveFirstLaunchUseCase: any SaveFirstLaunchUseCase
    private let requestNotificationAuthUseCase: any RequestNotificationAuthUseCase
    private let remoteSaveDeviceTokenUseCase: any RemoteSaveDeviceTokenUseCase

    init(
        presenter: (any HomePresentable)? = nil,
        loadUserInfoUseCase: any LoadUserInfoUseCase,
        checkFirstLaunchUseCase: any CheckFirstLaunchUseCase,
        saveFirstLaunchUseCase: any SaveFirstLaunchUseCase,
        requestNotificationAuthUseCase: any RequestNotificationAuthUseCase,
        remoteSaveDeviceTokenUseCase: any RemoteSaveDeviceTokenUseCase
    ) {
        self.presenter = presenter
        self.loadUserInfoUseCase = loadUserInfoUseCase
        self.checkFirstLaunchUseCase = checkFirstLaunchUseCase
        self.saveFirstLaunchUseCase = saveFirstLaunchUseCase
        self.requestNotificationAuthUseCase = requestNotificationAuthUseCase
        self.remoteSaveDeviceTokenUseCase = remoteSaveDeviceTokenUseCase
    }

    func loadInfo() throws -> UserInfo {
        try loadUserInfoUseCase.execute()
    }
    func saveDeviceToken() {
        guard checkFirstLaunchUseCase.execute() else { return }
        Task {
            do {
                try saveFirstLaunchUseCase.execute()
                let isAllowed = try await requestNotificationAuthUseCase.execute()
                guard isAllowed else { return }
                try await remoteSaveDeviceTokenUseCase.execute()
            } catch {
                SNMLogger.error(error.localizedDescription)
            }
        }
    }
}
