//
//  ProfileSetupPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

protocol ProfileCreatePresentable : AnyObject{
    var view: ProfileCreateViewable? { get set }
    var interactor: ProfileCreateInteractable? { get set }
    var router: ProfileCreateRoutable? { get set }
    
    func saveDogInfo(newDog: Dog)
}

final class ProfileCreatePresenter: ProfileCreatePresentable {
    weak var view: ProfileCreateViewable?
    var interactor: ProfileCreateInteractable?
    var router: ProfileCreateRoutable?
    
    func saveDogInfo(newDog: Dog) {
        
    }
}
