//
//  OnBoardingViewController.swift
//  SniffMeet
//
//  Created by 배현진 on 12/3/24.
//

import UIKit

class OnBoardingViewController: BaseViewController {
    private var pageViewController: UIPageViewController!
    private var pages: [OnBoardingPage] = []

    override func configureAttributes() {
        setupPageViewController()
        setButtonActions()
    }
    override func configureHierachy() {}
    override func configureConstraints() {}
    override func bind() {}

    private func setupPageViewController() {
        let page1 = OnBoardingPage(title: "SniffMeet", description: "SniffMeet 앱을 이용하세요", imageName: "placeholder")
        let page2 = OnBoardingPage(title: "프로필 드랍", description: "프로필 드랍을 이용하세요", imageName: "placeholder")
        let page3 = OnBoardingPage(title: "산책 요청", description: "산책 요청을 이용하세요", imageName: "placeholder")

        pages.append(page1)
        pages.append(page2)
        pages.append(page3)

        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        if let firstPage = pages.first {
            pageViewController.setViewControllers([OnBoardingPageViewController(page: firstPage)], direction: .forward, animated: false, completion: nil)
        }
    }

    func setButtonActions() {

    }
}

extension OnBoardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentVC = viewController as? OnBoardingPageViewController else {
            return nil
        }
        guard let index = pages.firstIndex(
            where: { $0.title == currentVC.page.title }
        ) else { return nil }
        return index > 0 ? OnBoardingPageViewController(
            page: pages[index - 1]
        ) : nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentVC = viewController as? OnBoardingPageViewController else {
            return nil
        }
        guard let index = pages.firstIndex(
            where: { $0.title == currentVC.page.title }
        ) else { return nil }
        return index < pages.count - 1 ? OnBoardingPageViewController(
            page: pages[index + 1]
        ) : nil
    }
}
