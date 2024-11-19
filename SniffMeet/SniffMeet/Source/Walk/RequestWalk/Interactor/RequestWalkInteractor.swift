//
//  RequestWalkInteractor.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

protocol RequestWalkInteractable: AnyObject {
    var presenter: RequestWalkInteractorOutput? { get set }
    func fetchDogDetail(dog: Int)
    func sendWalkRequest() /// parameter에 요청에 대한 엔티티가 있어야 함
}

final class RequestWalkInteractor: RequestWalkInteractable {
    weak var presenter: RequestWalkInteractorOutput?
    var requestWalkUsecase: RequestWalkUseCase
    
    init(presenter: RequestWalkInteractorOutput? = nil, usecase: RequestWalkUseCase) {
        self.presenter = presenter
        requestWalkUsecase = usecase
    }
    
    func fetchDogDetail(dog: Int) {
       ///  usecase로 얻어온 dog 정보를 받고 Presenter의 didFetchDogInfo를 호출한다.
    }
    func sendWalkRequest() {
        /// 서버를 통해서 산책 요청을 보낸다.
    }
}
