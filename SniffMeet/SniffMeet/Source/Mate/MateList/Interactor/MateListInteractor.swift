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
    private var mateList = [Mate]()

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
            mateList = await requestMateListUseCase.execute()
            presenter?.didFetchMateList(mateList: mateList)
        }
    }

    func requestProfileImage(index: Int, urlString: String?) {
        Task { @MainActor in
            let fileName = mateList[index].profileImageURLString
            let imageData = try await requestProfileImageUseCase.execute(fileName: fileName ?? "")
            presenter?.didFetchProfileImage(index: index, imageData: imageData)
        }
    }
}
