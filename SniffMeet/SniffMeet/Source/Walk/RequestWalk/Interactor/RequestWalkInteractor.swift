//
//  RequestWalkInteractor.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import Foundation

protocol RequestWalkInteractable: AnyObject {
    var mate: Mate { get }
    var presenter: RequestWalkInteractorOutput? { get set }
    func requestMateInfo()
    func requestProfileImage(imageName: String?)
    func sendWalkRequest() /// parameter에 요청에 대한 엔티티가 있어야 함
}

final class RequestWalkInteractor: RequestWalkInteractable {
    private(set) var mate: Mate
    weak var presenter: RequestWalkInteractorOutput?
    private let requestWalkUseCase: any RequestWalkUseCase
    // private let requestMateInfoUseCase: any RequestMateInfoUseCase
    private let requestProfileImageUseCase: any RequestProfileImageUseCase

    init(
        mate: Mate,
        presenter: RequestWalkInteractorOutput? = nil,
        requestWalkUseCase: any RequestWalkUseCase,
        // requestMateInfoUseCase: any RequestMateInfoUseCase,
        requestProfileImageUseCase: any RequestProfileImageUseCase
    ) {
        self.mate = mate
        self.presenter = presenter
        self.requestWalkUseCase = requestWalkUseCase
        // self.requestMateInfoUseCase = requestMateInfoUseCase
        self.requestProfileImageUseCase = requestProfileImageUseCase
    }

    func sendWalkRequest() {
        /// 서버를 통해서 산책 요청을 보낸다.
    }

    func requestMateInfo() {
        presenter?.didFetchMateInfo(mateInfo: mate)
    }

    func requestProfileImage(imageName: String?) {
        Task { @MainActor in
            let imageData = await requestProfileImageUseCase.execute()
            presenter?.didFetchProfileImage(imageData: imageData)
        }
    }
}
