//
//  RequestMateInteractor.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import Foundation

protocol RequestMateInteractable: AnyObject {
    var presenter: (any RequestMateInteractorOutput)? { get set }

    func fetchDogProfile()
    func saveMateInfo(id: UUID) async
}

final class RequestMateInteractor: RequestMateInteractable {
    weak var presenter: (any RequestMateInteractorOutput)?
    private let respondMateRequestUseCase: RespondMateRequestUseCase

    init(
        presenter: (any RequestMateInteractorOutput)? = nil,
        respondMateRequestUseCase: RespondMateRequestUseCase
    ) {
        self.presenter = presenter
        self.respondMateRequestUseCase = respondMateRequestUseCase
    }

    func fetchDogProfile() {
        /// 프로필 데이터 가져오고  presenter의 didFetchDogProfile 호출.
    }
    func saveMateInfo(id: UUID) async {
        await respondMateRequestUseCase.execute(mateId: id, isAccepted: true)
    }
}
