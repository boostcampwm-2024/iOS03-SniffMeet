//
//  HomeInteractor.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

protocol HomeInteractable: AnyObject {
    var presenter: (any HomePresentable)? { get }
    func loadInfo() throws -> Dog
}

final class HomeInteractor: HomeInteractable {
    weak var presenter: (any HomePresentable)?
    private let loadInfoUseCase: LoadDogInfoUseCase

    init(presenter: (any HomePresentable)? = nil, loadInfoUseCase: LoadDogInfoUseCase) {
        self.presenter = presenter
        self.loadInfoUseCase = loadInfoUseCase
    }

    func loadInfo() throws -> Dog {
        try loadInfoUseCase.execute()
    }
}
