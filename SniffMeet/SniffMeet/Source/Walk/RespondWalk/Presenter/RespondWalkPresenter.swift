//
//  RespondWalkPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import Foundation
import Combine

protocol RespondWalkPresentable : AnyObject {
    var requestNum: Int { get }
    var view: RespondWalkViewable? { get set }
    var interactor: RespondWalkInteractable? { get set }
    var router: RespondWalkRoutable? { get set }
    
    func viewDidLoad()
    func respondWalkRequest(walkRequestNumber: Int, isAccepted: Bool)
    func dismissView()
    func handleExceedingLimit() // 제한 시간 초과일 때 실행하는 함수
}

protocol RespondWalkInteractorOutput: AnyObject {
    func didFetchWalkRequest(walkRequest: WalkRequest) // fetch한 데이터를 보여준다.
    func didSendWalkRequest()
    func didFailToFetchWalkRequest(error: Error)
    func didFailToSendWalkRequest(error: Error)
}

final class RespondWalkPresenter: RespondWalkPresentable {
    var requestNum: Int
    weak var view: (any RespondWalkViewable)?
    var interactor: (any RespondWalkInteractable)?
    var router: (any RespondWalkRoutable)?
    
    init(requestNum: Int,
         view: (any RespondWalkViewable)? = nil,
         interactor: (any RespondWalkInteractable)? = nil,
         router: (any RespondWalkRoutable)? = nil)
    {
        self.requestNum = requestNum
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor?.fetchRequest(requestNum: requestNum)
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
    func didFetchWalkRequest(walkRequest: WalkRequest) {
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
}

