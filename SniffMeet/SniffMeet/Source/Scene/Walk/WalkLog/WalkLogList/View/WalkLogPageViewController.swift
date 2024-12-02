//
//  WalkLogPageViewController.swift
//  SniffMeet
//
//  Created by sole on 11/23/24.
//

import Combine
import UIKit

final class WalkLogPageViewController: BaseViewController {
    private var cancellables: Set<AnyCancellable> = []
    private var currentIndex: Int = 0
    private let lineTabBar: SNMLineTabBar = SNMLineTabBar(tabBarItems: Context.tabBarTitles)
    private let pageViewController: UIPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    // TODO: 실제 ViewController로 대체 필요
    private var dataSource: [UIViewController] = [
        WalkLogListViewController(),
        HomeViewController()
    ]

    override func configureAttributes() {
        navigationItem.title = Context.navigationTitle
        navigationItem.largeTitleDisplayMode = .never

        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers(
            [dataSource[currentIndex]],
            direction: .forward,
            animated: true
        )
    }
    override func configureHierachy() {
        addChild(pageViewController)

        [lineTabBar,
         pageViewController.view].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            lineTabBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 8
            ),
            lineTabBar.heightAnchor.constraint(
                equalToConstant: lineTabBar.intrinsicContentSize.height
            ),
            lineTabBar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            lineTabBar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.horizontalPadding
            ),
            pageViewController.view.topAnchor.constraint(equalTo: lineTabBar.bottomAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    override func bind() {
        lineTabBar.valueChangedPublisher()
            .sink { [weak self] index in
                self?.updatePageViewController(index: index)
                self?.currentIndex = index
            }
            .store(in: &cancellables)
    }

    private func updatePageViewController(index: Int) {
        guard currentIndex != index,
              index < dataSource.count else { return }
        let direction: UIPageViewController.NavigationDirection = currentIndex < index ?
            .forward : .reverse
        pageViewController.setViewControllers(
            [dataSource[index]],
            direction: direction,
            animated: true
        )
    }
}

// MARK: - WalkLogPageViewController+Context

private extension WalkLogPageViewController {
    enum Context {
        static let tabBarTitles: [String] = ["로그", "리포트"]
        static let navigationTitle: String = "기록"
    }
}

// MARK: - WalkLogPageViewController+UIPageViewControllerDelegate, DataSource

extension WalkLogPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
       _ pageViewController: UIPageViewController,
       didFinishAnimating finished: Bool,
       previousViewControllers: [UIViewController],
       transitionCompleted completed: Bool
     ) {
       guard
        let viewController = pageViewController.viewControllers?.first,
        let viewIndex = dataSource.firstIndex(of: viewController) else { return }
         lineTabBar.selectTab(index: viewIndex)
     }
}

extension WalkLogPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataSource.firstIndex(of: viewController),
              index - 1 > -1 else { return nil }
        return dataSource[index - 1]
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataSource.firstIndex(of: viewController),
              index + 1 < dataSource.count else { return nil }
        return dataSource[index + 1]
    }
}
