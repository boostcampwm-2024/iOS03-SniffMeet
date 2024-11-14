//
//  ProfileCreateInteractable.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

protocol ProfileCreateInteractable: AnyObject {
    var presenter: ProfileCreatePresentable? { get set }
}

final class ProfileCreateInteractor: ProfileCreateInteractable {
    weak var presenter: ProfileCreatePresentable?
}
