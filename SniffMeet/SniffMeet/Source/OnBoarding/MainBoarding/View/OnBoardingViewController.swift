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
    private var skipButtoon = PrimaryButton(title: Context.skipLabel)
    private var pageControl: UIPageControl!

    override func configureAttributes() {
        setupPageViewController()
        setButtonActions()
    }
    override func configureHierachy() {
        [skipButtoon,
         pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            skipButtoon.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            skipButtoon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButtoon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageControl.bottomAnchor.constraint(equalTo: skipButtoon.topAnchor, constant: -30),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
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

        pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = SNMColor.mainNavy
        pageControl.pageIndicatorTintColor = SNMColor.mainBrown
    }

    func setButtonActions() {

    }

    func updatePageControl(for index: Int) {
        pageControl.currentPage = index
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

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first as? OnBoardingPageViewController,
              let currentIndex = pages.firstIndex(where: { $0.title == currentVC.page.title }) else {
            return
        }
        updatePageControl(for: currentIndex)
    }
}

private extension OnBoardingViewController {
    enum Context {
        static let skipLabel: String = "Skip"
    }
}
