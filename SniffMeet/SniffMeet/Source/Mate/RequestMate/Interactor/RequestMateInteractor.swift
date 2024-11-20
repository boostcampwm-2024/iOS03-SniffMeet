//
//  RequestMateInteractor.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

protocol RequestMateInteractable: AnyObject {
    func fetchDogProfile()
}

final class RequestMateInteractor: RequestMateInteractable {
    weak var presenter: RequestMatePresentable?

    func fetchDogProfile() {
        /// 프로필 데이터 가져오고  presenter의 didFetchDogProfile 호출.
    }
}
