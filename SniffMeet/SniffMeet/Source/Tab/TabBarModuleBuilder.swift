//
//  TabBarModuleBuilder.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/11/24.
//

import UIKit

enum TabBarModuleBuilder {
    static func build(usingSubmodules submodules: MainTabs) -> UITabBarController {
        let homeTabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        let walkTabBarItem = UITabBarItem(
            title: "walk",
            image: UIImage(systemName: "dog.fill"),
            tag: 1
        )
        let mateTabBarItem = UITabBarItem(
            title: "mate",
            image: UIImage(systemName: "heart.fill"),
            tag: 2
        )

        submodules.home.tabBarItem = homeTabBarItem
        submodules.walk.tabBarItem = walkTabBarItem
        submodules.mate.tabBarItem = mateTabBarItem

        let tabs = (submodules.home, submodules.walk, submodules.mate)
        let tabBarController = TabBarController(tabs: tabs)
        return tabBarController
    }
}
