//
//  RequestWalkPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import Combine
import Foundation

protocol RequestWalkPresentable : AnyObject{
    var view: RequestWalkViewable? { get set }
    var interactor: RequestWalkInteractable? { get set }
    var router: RequestWalkRoutable? { get set }
    var output: RequestWalkPresenterOutput { get set }
    
    func viewDidLoad()
    func requestWalk(message: String, latitude: Double, longtitude: Double, location: String)
    func closeTheView()
    func didTapLocationButton()
    func didSelectLocation(with: Address?)
}

protocol RequestWalkInteractorOutput: AnyObject {
    func didFetchMateInfo(mateInfo: Mate)
    func didFetchProfileImage(imageData: Data?)
    func didSendWalkRequest()
    func didFailToFetchDogInfo(error: Error)
    func didFailToSendWalkRequest(error: Error)
}

final class RequestWalkPresenter: RequestWalkPresentable {
    weak var view: RequestWalkViewable?
    var interactor: RequestWalkInteractable?
    var router: RequestWalkRoutable?
    var output: RequestWalkPresenterOutput
    
    // FIXME: dogInfo defaultValue 제거 필요
    init(
        view: RequestWalkViewable? = nil,
        interactor: RequestWalkInteractable? = nil,
        router: RequestWalkRoutable? = nil,
        output: RequestWalkPresenterOutput = DefaultRequestWalkPresenterOutput(
            selectedLocation: CurrentValueSubject(nil)
        )
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.output = output
    }
    
    func viewDidLoad() {
        // interactor에서 메이트 정보 받아오고 -> url에서 사진 받아오기 (캐싱 사용)
        interactor?.requestMateInfo()
    }
    
    func requestWalk(message: String, latitude: Double, longtitude: Double, location: String) {
        interactor?.sendWalkRequest(message: message,
                                    latitude: latitude,
                                    longtitude: longtitude,
                                    location: location)
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
    func didFetchMateInfo(mateInfo: Mate) {
        output.mateInfo.send(mateInfo)
        if let profileImageName = mateInfo.profileImageURLString {
            interactor?.requestProfileImage(imageName: profileImageName)
        }
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
    func didFetchProfileImage(imageData: Data?) {
        output.profileImageData.send(imageData)
    }
}

protocol RequestWalkPresenterOutput {
    var selectedLocation: CurrentValueSubject<Address?, Never> { get }
    var profileImageData: PassthroughSubject<Data?, Never> { get }
    var mateInfo: PassthroughSubject<Mate?, Never> { get }
}

struct DefaultRequestWalkPresenterOutput: RequestWalkPresenterOutput {
    let selectedLocation: CurrentValueSubject<Address?, Never>
    let profileImageData = PassthroughSubject<Data?, Never>()
    let mateInfo = PassthroughSubject<Mate?, Never>()
}
