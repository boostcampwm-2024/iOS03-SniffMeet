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
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
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
