//
//  HomeInteractor.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

protocol HomeInteractable: AnyObject {
    var presenter: (any HomePresentable)? { get }
    func loadInfo() throws -> UserInfo
}

final class HomeInteractor: HomeInteractable {
    weak var presenter: (any HomePresentable)?
    private let loadUserInfoUseCase: LoadUserInfoUseCase

    init(presenter: (any HomePresentable)? = nil, loadUserInfoUseCase: LoadUserInfoUseCase) {
        self.presenter = presenter
        self.loadUserInfoUseCase = loadUserInfoUseCase
    }

    func loadInfo() throws -> UserInfo {
        try loadUserInfoUseCase.execute()
    }
}
