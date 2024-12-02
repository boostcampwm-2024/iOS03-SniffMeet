//
//  RequestWalkInteractor.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import Foundation

protocol RequestWalkInteractable: AnyObject {
    var presenter: RequestWalkInteractorOutput? { get set }
    func requestMateInfo()
    func requestProfileImage(imageName: String?)
    func sendWalkRequest(message: String, latitude: Double, longtitude: Double, location: String)
}

final class RequestWalkInteractor: RequestWalkInteractable {
    private(set) var mate: Mate
    weak var presenter: RequestWalkInteractorOutput?
    private let requestWalkUseCase: any RequestWalkUseCase
    // private let requestMateInfoUseCase: any RequestMateInfoUseCase
    private let requestProfileImageUseCase: any RequestProfileImageUseCase
    private let loadUserInfoUseCase: any LoadUserInfoUseCase

    init(
        mate: Mate,
        presenter: RequestWalkInteractorOutput? = nil,
        requestWalkUseCase: any RequestWalkUseCase,
        // requestMateInfoUseCase: any RequestMateInfoUseCase,
        requestProfileImageUseCase: any RequestProfileImageUseCase,
        loadUserInfoUseCase: any LoadUserInfoUseCase
    ) {
        self.mate = mate
        self.presenter = presenter
        self.requestWalkUseCase = requestWalkUseCase
        // self.requestMateInfoUseCase = requestMateInfoUseCase
        self.requestProfileImageUseCase = requestProfileImageUseCase
        self.loadUserInfoUseCase = loadUserInfoUseCase
    }

    func sendWalkRequest(message: String, latitude: Double, longtitude: Double, location: String) {
        guard let id = SessionManager.shared.session?.user?.userID else { return }
        guard let myInfo = try? loadUserInfoUseCase.execute() else { return }
        
        let walkNoti = WalkNotiDTO(id: UUID(),
                                   createdAt: Date().convertDateToISO8601String(),
                                   message: message,
                                   latitude: latitude,
                                   longtitude: longtitude,
                                   senderId: id,
                                   receiverId: mate.userID,
                                   senderName: myInfo.name,
                                   category: .walkRequest)
        Task {
            do {
                try await requestWalkUseCase.execute(walkNoti: walkNoti)

            } catch {
                SNMLogger.error("RequestWalkInteractor: \(error.localizedDescription)")
            }
        }
        presenter?.didSendWalkRequest()
    }

    func requestMateInfo() {
        presenter?.didFetchMateInfo(mateInfo: mate)
    }

    func requestProfileImage(imageName: String?) {
        Task { @MainActor in
            let fileName = mate.profileImageURLString ?? ""
            let imageData = try await requestProfileImageUseCase.execute(fileName: fileName)
            presenter?.didFetchProfileImage(imageData: imageData)
        }
    }
}
