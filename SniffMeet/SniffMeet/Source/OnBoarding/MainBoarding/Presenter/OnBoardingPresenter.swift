//
//  OnBoardingPresenter.swift
//  SniffMeet
//
//  Created by 배현진 on 12/4/24.
//

import Foundation

protocol OnBoardingPresentable: AnyObject {
    var view: (any OnBoardingViewable)? { get set }
    var interactor: (any OnBoardingInteractable)? { get set }
    var router: (any OnBoardingRoutable)? { get set }

    func viewDidLoad()
    func skipOnboarding()
    func pageAt(index: Int) -> OnBoardingPage?
}

final class OnBoardingPresenter: OnBoardingPresentable {
    weak var view: (any OnBoardingViewable)?
    var interactor: (any OnBoardingInteractable)?
    var router: (any OnBoardingRoutable)?
    private var pages: [OnBoardingPage] = []

    init(
        view: (any OnBoardingViewable)? = nil,
        interactor: (any OnBoardingInteractable)? = nil,
        router: (any OnBoardingRoutable)? = nil
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        SNMLogger.log("presenter viewDidLoad")
        pages = interactor?.fetchPages() ?? []
        SNMLogger.info("page3: \(pages)")
        view?.updatePages(pages)
    }

    func skipOnboarding() {
        router?.navigateToMainScreen()
    }

    func pageAt(index: Int) -> OnBoardingPage? {
        guard index >= 0 && index < pages.count else { return nil }
        return pages[index]
    }
}
