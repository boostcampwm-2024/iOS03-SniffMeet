//
//  ProfileInputPresenter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//

protocol ProfileInputPresentable {
    var view: ProfileInputViewable? { get set }
    var router: ProfileInputRoutable? { get set }
    func moveToProfileCreateView()
}


final class ProfileInputPresenter: ProfileInputPresentable {
    weak var view: ProfileInputViewable?
    var router: ProfileInputRoutable?
    
    func moveToProfileCreateView() {
        
    }
}
