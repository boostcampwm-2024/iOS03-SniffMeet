//
//  TabBarConfigurator.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/10/24.
//

import UIKit

final class MainTabBarFactory {
    func configure() -> UITabBarController {
        let tabBarController = UITabBarController()
        let mainViewController = UINavigationController(rootViewController: UIViewController())
        let walkViewController = UINavigationController(rootViewController: UIViewController())
        let mateViewController = UINavigationController(rootViewController: UIViewController())

        mainViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            selectedImage: nil
        )
        walkViewController.tabBarItem = UITabBarItem(
            title: "Walk",
            image: UIImage(systemName: "dog.fill"),
            selectedImage: nil
        )
        mateViewController.tabBarItem = UITabBarItem(
            title: "Mate",
            image: UIImage(systemName: "heart.fill"),
            selectedImage: nil
        )
        tabBarController.setViewControllers(
            [mainViewController, walkViewController, mateViewController],
            animated: false
        )

        tabBarController.tabBar.backgroundColor = .systemBackground
        setBorder(for: tabBarController.tabBar.layer)

        return tabBarController
    }

    private func setBorder(for layer: CALayer) {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: -0.5)
        layer.shadowRadius = 0
    }
}
