//
//  ProfileSetupPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import Foundation
import UIKit

protocol ProfileCreatePresentable : AnyObject{
    var dogInfo: DogDetailInfo { get set }
    var view: ProfileCreateViewable? { get set }
    var interactor: ProfileCreateInteractable? { get set }
    var router: ProfileCreateRoutable? { get set }
    
    func didTapSubmitButton(nickname: String, image: UIImage?)
}

protocol DogInfoInteractorOutput: AnyObject {
    func didSaveDogInfo()
    func didFailToSaveDogInfo(error: Error)
}


final class ProfileCreatePresenter: ProfileCreatePresentable {
    var dogInfo: DogDetailInfo
    weak var view: ProfileCreateViewable?
    var interactor: ProfileCreateInteractable?
    var router: ProfileCreateRoutable?
    
    init(dogInfo: DogDetailInfo,
         view: ProfileCreateViewable? = nil,
         interactor: ProfileCreateInteractable? = nil,
         router: ProfileCreateRoutable? = nil)
    {
        self.dogInfo = dogInfo
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func didTapSubmitButton(nickname: String, image: UIImage?) {
        let imageData = interactor?.convertImageToData(image: image)
        let dogInfo = Dog(name: dogInfo.name,
                      age: dogInfo.age,
                      sex: dogInfo.sex,
                      sexUponIntake: dogInfo.sexUponIntake,
                      size: dogInfo.size,
                      keywords: dogInfo.keywords,
                      nickname: nickname,
                      profileImage: imageData)
        // TODO: SubmitButton disable 필요
        interactor?.signInWithProfileData(dogInfo: dogInfo)
    }
}

extension ProfileCreatePresenter: DogInfoInteractorOutput {
    func didSaveDogInfo() {
        // TODO: submit button enable
        guard let view else { return }
        router?.presentMainScreen(from: view)
    }
    
    func didFailToSaveDogInfo(error: any Error) {
        // TODO: -  alert 올리는데 어떻게 올릴지 정하기
        // TODO: submit button enable
    }
}
