//
//  RequestWalkPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//
import Foundation

protocol RequestWalkPresentable : AnyObject{
    var dogInfo: Int { get set }
    var view: RequestWalkViewable? { get set }
    var interactor: RequestWalkInteractable? { get set }
    var router: RequestWalkRoutable? { get set }
    
    func viewDidLoad()
    func requestWalk(forPost walkRequest: String, to user: Int)
    func closeTheView()
}

protocol RequestWalkInteractorOutput: AnyObject {
    func didFetchDogInfo(dog: Dog)
    func didSendWalkRequest()
    func didFailToFetchDogInfo(error: Error)
    func didFailToSendWalkRequest(error: Error)
}


final class RequestWalkPresenter: RequestWalkPresentable {    
    var dogInfo: Int = 0
    weak var view: RequestWalkViewable?
    var interactor: RequestWalkInteractable?
    var router: RequestWalkRoutable?
    
    func viewDidLoad() {
        interactor?.fetchDogDetail(dog: dogInfo)
    }
    
    func requestWalk(forPost walkRequest: String, to user: Int) {
        interactor?.sendWalkRequest()
    }
    func closeTheView() {
        if let view {
            router?.dismissView(view: view)
        }
    }
}

extension RequestWalkPresenter: RequestWalkInteractorOutput {
    func didFetchDogInfo(dog: Dog) {
        /// interactor에서 얻어온 dog 정보를 view에 보여줌
    }
    func didSendWalkRequest() {
        if let view {
            router?.dismissView(view: view)
        }
    }
    
    func didFailToFetchDogInfo(error: any Error) {
        /// 반려견 정보를 가져오는 것을 실패했을 때 실행할 로직
    }
    
    func didFailToSendWalkRequest(error: any Error) {
        /// 산책 요청이 실패했을 때 실행할 로직
    }
}
