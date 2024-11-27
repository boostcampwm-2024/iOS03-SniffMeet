//
//  RequestMatePresenter.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

protocol RequestMatePresentable: AnyObject {
    func didFetchDogProfile(_ dogProfile: DogProfileDTO)
    func viewDidLoad()
}

final class RequestMatePresenter: RequestMatePresentable {
    weak var view: RequestMateViewable?
    var interactor: RequestMateInteractable?
    var router: RequestMateRoutable?

    func viewDidLoad() {
        interactor?.fetchDogProfile()
    }

    func didFetchDogProfile(_ dogProfile: DogProfileDTO) {
    }
}
