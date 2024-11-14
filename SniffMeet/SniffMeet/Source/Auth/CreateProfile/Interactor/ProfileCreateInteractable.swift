//
//  ProfileCreateInteractable.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

protocol ProfileCreateInteractable: AnyObject {
    var dogDetailInfo: DogDetailInfo? { get set }
    var presenter: ProfileCreatePresentable? { get set }
}

final class ProfileCreateInteractor: ProfileCreateInteractable {
    var dogDetailInfo: DogDetailInfo? 
    weak var presenter: ProfileCreatePresentable?
}
