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
        OnBoardingPage(
            title: "직접적인\n연락처 공유없이\n산책 메이트를 만들고\n언제든 산책 요청 보내기",
            description: "SniffMEET에서 가능해요!",
            imageName: "AppImage",
            isGif: false
        ),
        OnBoardingPage(
            title: "프로필 드랍",
            description: "새로운 메이트를 추가하고 싶다면\n메이트 목록에서 친구만들기 버튼을 누르고\n위에처럼 움직이며 프로필 드랍을 이용하세요.",
            imageName: "ProfileDrop",
            isGif: true
        ),
        OnBoardingPage(
            title: "산책 요청",
            description: "관계가 형성된 메이트들에게\n자유롭게 산책 요청을 보내고 받아보세요.\n만날 장소를 지정해 요청을 보낼 수 있어요.",
            imageName: "WalkingDog",
            isGif: false
        )
    ]

    func fetchPages() -> [OnBoardingPage] {
        SNMLogger.log("interactor fetchPages")
        return pages
    }
}
