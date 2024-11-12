//
//  TabBarModuleBuilder.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/11/24.
//

import UIKit

final class TabBarModuleBuilder {}

extension TabBarModuleBuilder {
    static func build(usingSubmodules submodules: MainTabs) -> UITabBarController {
        let tabs = TabBarRouter.makeTabs(usingSubmodules: submodules)
        let tabBarController = TabBarController(tabs: tabs)
        return tabBarController
    }
}
