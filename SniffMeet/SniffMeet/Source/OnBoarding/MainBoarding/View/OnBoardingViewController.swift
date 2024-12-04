//
//  OnBoardingViewController.swift
//  SniffMeet
//
//  Created by 배현진 on 12/3/24.
//

import UIKit

protocol OnBoardingViewable: AnyObject {
    var presenter: (any OnBoardingPresentable)? { get set }

    func updatePages(_ pages: [OnBoardingPage])
}

class OnBoardingViewController: BaseViewController, OnBoardingViewable {
    var presenter: (any OnBoardingPresentable)?
    private var pageViewController: UIPageViewController!
    private var pages: [OnBoardingPage] = []
    private var skipButtoon = PrimaryButton(title: Context.skipLabel)
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = SNMColor.mainNavy
        pageControl.pageIndicatorTintColor = SNMColor.mainBrown
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
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
        SNMLogger.log("setupPageViewController")
        SNMLogger.info("page: \(pages)")
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

//        if let firstPage = self.pages.first {
//            pageViewController.setViewControllers([OnBoardingPageViewController(page: firstPage)], direction: .forward, animated: false, completion: nil)
//        }
    }

    func setButtonActions() {

    }

    func updatePageControl(for index: Int) {
        pageControl.currentPage = index
    }

    func updatePages(_ pages: [OnBoardingPage]) {
        self.pages = pages
        SNMLogger.info("page2: \(pages)")
//        if let firstPage = self.pages.first {
//            pageViewController.setViewControllers([OnBoardingPageViewController(page: firstPage)], direction: .forward, animated: false, completion: nil)
//        }
        if let firstPage = presenter?.pageAt(index: 0) {
            let firstVC = OnBoardingPageViewController(page: firstPage)
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: false)
        }
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
