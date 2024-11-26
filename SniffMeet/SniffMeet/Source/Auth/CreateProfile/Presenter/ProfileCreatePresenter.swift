//
//  ProfileSetupPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import Foundation

protocol ProfileCreatePresentable : AnyObject{
    var dogInfo: DogDetailInfo { get set }
    var view: ProfileCreateViewable? { get set }
    var interactor: ProfileCreateInteractable? { get set }
    var router: ProfileCreateRoutable? { get set }
    
    func saveDogInfo(nickname: String, imageData: Data?)
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
    
    func saveDogInfo(nickname: String, imageData: Data?) {
        let dog = Dog(name: dogInfo.name,
                      age: dogInfo.age,
                      sex: dogInfo.sex,
                      sexUponIntake: dogInfo.sexUponIntake,
                      size: dogInfo.size,
                      keywords: dogInfo.keywords,
                      nickname: nickname,
                      profileImage: imageData)
        interactor?.saveDogInfo(dogInfo: dog)
    }
}

extension ProfileCreatePresenter: DogInfoInteractorOutput {
    func didSaveDogInfo() {
        guard let view else { return }
        Task {
            await SupabaseAuthManager.shared.signInAnonymously()
        }
        router?.presentMainScreen(from: view)
    }
    
    func didFailToSaveDogInfo(error: any Error) {
        // TODO: -  alert 올리는데 어떻게 올릴지 정하기
    }
}
