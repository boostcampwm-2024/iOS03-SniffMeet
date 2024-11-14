//
//  ProfileInputPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

protocol ProfileInputPresentable {
    var view: ProfileInputViewable? { get set }
    var router: ProfileInputRoutable? { get set }
    func moveToProfileCreateView(with newDogDetailInfo: DogDetailInfo)
}


final class ProfileInputPresenter: ProfileInputPresentable {
    weak var view: ProfileInputViewable?
    var router: ProfileInputRoutable?
    
    func moveToProfileCreateView(with newDogDetailInfo: DogDetailInfo) {
        guard let view else { return }
        router?.presentPostCreateScreen(from: view, with: newDogDetailInfo)
    }
}
