//
//  RespondWalkPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Combine
import Foundation

protocol RespondWalkPresentable : AnyObject {
    var noti: WalkNoti { get }
    var view: RespondWalkViewable? { get set }
    var interactor: RespondWalkInteractable? { get set }
    var router: RespondWalkRoutable? { get set }
    var output: (any RespondWalkPresenterOutput) { get }

    func viewDidLoad()
    func respondWalkRequest(walkRequestNumber: Int, isAccepted: Bool)
    func dismissView()
    func handleExceedingLimit() // 제한 시간 초과일 때 실행하는 함수
}

protocol RespondWalkInteractorOutput: AnyObject {
    func didFetchUserInfo(senderInfo: Dog) // fetch한 데이터를 보여준다.
    func didSendWalkRequest()
    func didCalculateTimeLimit(secondDifference: Int)
    func didConvertLocationToText(with location: String?)
    func didFailToFetchWalkRequest(error: Error)
    func didFailToSendWalkRequest(error: Error)
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
            locationLabel: CurrentValueSubject<String?, Never>(nil)
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
            await interactor?.convertLocationToText(latitude: noti.latitude, longtitude: noti.longtitude)
        }
    }
    func respondWalkRequest(walkRequestNumber: Int, isAccepted: Bool) {
        interactor?.respondWalkRequest(requestNum: walkRequestNumber, isAccepted: isAccepted)
    }
    func dismissView() {
        guard let view else {return}
        router?.dismissView(view: view)
    }
    func handleExceedingLimit() {
        
    }
}

extension RespondWalkPresenter: RespondWalkInteractorOutput {
    func didConvertLocationToText(with location: String?) {
        output.locationLabel.send(location)
    }
    
    func didFetchUserInfo(senderInfo: Dog) {
        let walkRequest = WalkRequest(dog: senderInfo,
                                      address: Address(longtitude: noti.longtitude,
                                                       latitude: noti.latitude),
                                      message: noti.message)
        
        view?.showRequestDetail(request: walkRequest)
    }
    
    func didSendWalkRequest() {
        dismissView()
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
}

struct DefaultRespondWalkPresenterOutput: RespondWalkPresenterOutput {
    let locationLabel: CurrentValueSubject<String?, Never>
}
