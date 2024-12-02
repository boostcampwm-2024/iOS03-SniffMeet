//
//  RespondWalkPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Combine
import UIKit

protocol RespondWalkPresentable : AnyObject {
    var noti: WalkNoti { get }
    var view: RespondWalkViewable? { get set }
    var interactor: RespondWalkInteractable? { get set }
    var router: RespondWalkRoutable? { get set }
    var output: (any RespondWalkPresenterOutput) { get }

    func viewDidLoad()
    func respondWalkRequest(isAccepted: Bool)
    func dismissView()
    func handleExceedingLimit() // 제한 시간 초과일 때 실행하는 함수
    func didTapLocationViewButton()
}

protocol RespondWalkInteractorOutput: AnyObject {
    func didFetchUserInfo(senderInfo: UserInfoDTO)
    func didSendWalkRespond()
    func didCalculateTimeLimit(secondDifference: Int)
    func didConvertLocationToText(with location: String?)
    func didFetchProfileImage(with imageData: Data?)
    func didFailToSendWalkRequest(error: Error)
    func didFailToFetchWalkRequest(error: Error)
}

final class RespondWalkPresenter: RespondWalkPresentable {    
    var noti: WalkNoti
    weak var view: (any RespondWalkViewable)?
    var interactor: (any RespondWalkInteractable)?
    var router: (any RespondWalkRoutable)?
    var output: (any RespondWalkPresenterOutput)

    init(noti: WalkNoti,
         view: (any RespondWalkViewable)? = nil,
         interactor: (any RespondWalkInteractable)? = nil,
         router: (any RespondWalkRoutable)? = nil,
         output: RespondWalkPresenterOutput =  DefaultRespondWalkPresenterOutput(
            locationLabel: CurrentValueSubject<String?, Never>(nil),
            profileImage: CurrentValueSubject<UIImage?, Never>(nil)
         )
    )
    {
        self.noti = noti
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
    }
    
    func viewDidLoad() {
        interactor?.fetchSenderInfo(userId: noti.senderId)
        guard let createdAt = noti.createdAt else { return }
        interactor?.calculateTimeLimit(requestTime: createdAt)
        Task {
            await interactor?.convertLocationToText(
                latitude: noti.latitude,
                longtitude: noti.longtitude
            )
        }
    }
    func respondWalkRequest(isAccepted: Bool) {
        let walkNotiCategory: WalkNotiCategory = isAccepted == true ? .walkAccepted : .walkDeclined
        guard let date = noti.createdAt?.convertDateToISO8601String(),
              let id = SessionManager.shared.session?.user?.userID else { return }
        
        let walkNoti = WalkNotiDTO(id: noti.id,
                                   createdAt: date,
                                   message: noti.message,
                                   latitude: noti.latitude,
                                   longtitude: noti.longtitude,
                                   senderId: id,
                                   receiverId: noti.senderId,
                                   senderName: noti.senderName,
                                   category: walkNotiCategory)
        interactor?.respondWalkRequest(walkNoti: walkNoti)
    }
    func dismissView() {
        guard let view else {return}
        router?.dismissView(view: view)
    }
    func handleExceedingLimit() {

    }
    func didTapLocationViewButton() {
        guard let view else { return }
        let address: Address = Address(longtitude: noti.longtitude, latitude: noti.latitude)
        router?.showSelectedLocationMapView(view: view, address: address)
    }
}

extension RespondWalkPresenter: RespondWalkInteractorOutput {
    func didConvertLocationToText(with location: String?) {
        output.locationLabel.send(location)
    }
    
    func didFetchUserInfo(senderInfo: UserInfoDTO) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let walkRequest = WalkRequest(mate: senderInfo.toEntity(),
                                          address: Address(longtitude: self.noti.longtitude,
                                                           latitude: self.noti.latitude),
                                          message: self.noti.message)

            self.view?.showRequestDetail(request: walkRequest)
        }
    }
    
    func didSendWalkRespond() {
        dismissView()
    }
    
    func didFetchProfileImage(with imageData: Data?) {
        guard let imageData else {
            output.profileImage.send(nil)
            return
        }
        let image = UIImage(data: imageData)
        output.profileImage.send(image)
    }
    
    func didFailToFetchWalkRequest(error: any Error) {
        // TODO: -  에러 구체화 필요
        view?.showError()
    }
    
    func didFailToSendWalkRequest(error: any Error) {
        // TODO: -  에러 구체화 필요
        view?.showError()
    }
    func didCalculateTimeLimit(secondDifference: Int) {
        view?.startTimer(countDownValue: secondDifference)
    }
}

// MARK: - RespondWalkPresenterOutput

protocol RespondWalkPresenterOutput {
    var locationLabel: CurrentValueSubject<String?, Never> { get }
    var profileImage: CurrentValueSubject<UIImage?, Never> { get }
}

struct DefaultRespondWalkPresenterOutput: RespondWalkPresenterOutput {
    let locationLabel: CurrentValueSubject<String?, Never>
    let profileImage: CurrentValueSubject<UIImage?, Never>
}
