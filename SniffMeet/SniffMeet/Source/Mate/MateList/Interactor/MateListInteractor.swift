//
//  MateListPresentable.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/21/24.
//

import Foundation

protocol MateListInteractable: AnyObject {
    var presenter: MateListInteractorOutput? { get set }

    func requestMateList(userID: UUID)
    func requestProfileImage(index: Int, urlString: String?)
}

final class MateListInteractor: MateListInteractable {
    weak var presenter: (any MateListInteractorOutput)?
    private let requestMateListUseCase: any RequestMateListUseCase
    private let requestProfileImageUseCase: any RequestProfileImageUseCase

    init(
        presenter: (any MateListInteractorOutput)? = nil,
        requestMateListUseCase: any RequestMateListUseCase,
        requestProfileImageUseCase: any RequestProfileImageUseCase

    ) {
        self.presenter = presenter
        self.requestMateListUseCase = requestMateListUseCase
        self.requestProfileImageUseCase = requestProfileImageUseCase
    }

    func requestMateList(userID: UUID) {
        Task { @MainActor in
            let mateList = await requestMateListUseCase.execute()
            presenter?.didFetchMateList(mateList: mateList)
        }
    }

    func requestProfileImage(index: Int, urlString: String?) {
        Task { @MainActor in
            let imageData = await requestProfileImageUseCase.execute()
            presenter?.didFetchProfileImage(index: index, imageData: imageData)
        }
    }
}
