//
//  OnBoardingInteractor.swift
//  SniffMeet
//
//  Created by 배현진 on 12/4/24.
//

import Foundation

protocol OnBoardingInteractable: AnyObject {
    var presenter: (any OnBoardingPresentable)? { get set }

    func fetchPages() -> [OnBoardingPage]
}

final class OnBoardingInteractor: OnBoardingInteractable {
    weak var presenter: (any OnBoardingPresentable)?

    init(
        presenter: (any OnBoardingPresentable)? = nil
    ) {
        self.presenter = presenter
    }

    private let pages = [
        OnBoardingPage(title: "SniffMeet", description: "SniffMeet 앱을 이용하세요", imageName: "placeholder", isGif: false),
        OnBoardingPage(title: "프로필 드랍", description: "프로필 드랍을 이용하세요", imageName: "ProfileDrop", isGif: true),
        OnBoardingPage(title: "산책 요청", description: "산책 요청을 이용하세요", imageName: "placeholder", isGif: false)
    ]

    func fetchPages() -> [OnBoardingPage] {
        SNMLogger.log("interactor fetchPages")
        return pages
    }
}
