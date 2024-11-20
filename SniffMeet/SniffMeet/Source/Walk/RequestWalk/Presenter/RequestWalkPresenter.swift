//
//  RequestWalkPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import Combine
import Foundation

protocol RequestWalkPresentable : AnyObject{
    var dogInfo: Int { get set }
    var view: RequestWalkViewable? { get set }
    var interactor: RequestWalkInteractable? { get set }
    var router: RequestWalkRoutable? { get set }
    var output: RequestWalkPresenterOutput { get set }
    
    func viewDidLoad()
    func requestWalk(forPost walkRequest: String, to user: Int)
    func closeTheView()
    func didTapLocationButton()
    func didSelectLocation(with: Address?)
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
    var output: RequestWalkPresenterOutput
    
    // FIXME: dogInfo defaultValue 제거 필요
    init(
        dogInfo: Int = 0,
        view: RequestWalkViewable? = nil,
        interactor: RequestWalkInteractable? = nil,
        router: RequestWalkRoutable? = nil,
        output: RequestWalkPresenterOutput = DefaultRequestWalkPresenterOutput(
            selectedLocation: CurrentValueSubject(nil)
        )
    ) {
        self.dogInfo = dogInfo
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
    }
    
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
    func didTapLocationButton() {
        if let view {
            router?.showSelectLocationView(from: view)
        }
    }
    func didSelectLocation(with address: Address?) {
        output.selectedLocation.send(address)
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

protocol RequestWalkPresenterOutput {
    var selectedLocation: CurrentValueSubject<Address?, Never> { get }
}

struct DefaultRequestWalkPresenterOutput: RequestWalkPresenterOutput {
    let selectedLocation: CurrentValueSubject<Address?, Never>
}
