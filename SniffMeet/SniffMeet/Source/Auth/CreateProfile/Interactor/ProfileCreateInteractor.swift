//
//  ProfileCreateInteractable.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

protocol ProfileCreateInteractable: AnyObject {
    var presenter: DogInfoInteractorOutput? { get set }
    var storeDogInfoUsecase: StoreDogInfoUseCase { get set }
    
    func saveDogInfo(dogInfo: Dog)
}

final class ProfileCreateInteractor: ProfileCreateInteractable {
    weak var presenter: DogInfoInteractorOutput?
    var storeDogInfoUsecase: StoreDogInfoUseCase
    
    init(presenter: DogInfoInteractorOutput? = nil, usecase: StoreDogInfoUseCase) {
        self.presenter = presenter
        storeDogInfoUsecase = usecase
    }
    
    func saveDogInfo(dogInfo: Dog) {
        do {
            try storeDogInfoUsecase.execute(dog: dogInfo)
            presenter?.didSaveDogInfo()
        } catch (let error){
            presenter?.didFailToSaveDogInfo(error: error)
        }
    }
}
