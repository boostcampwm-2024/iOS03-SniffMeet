//
//  TabBarController.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/11/24.
//

import UIKit

typealias MainTabs = (
    home: UIViewController,
//    walk: UIViewController,
    mate: UIViewController
)

final class TabBarController: UITabBarController {
    init(tabs: MainTabs) {
        super.init(nibName: nil, bundle: nil)
//        viewControllers = [tabs.home, tabs.walk, tabs.mate]
        viewControllers = [tabs.home, tabs.mate]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
