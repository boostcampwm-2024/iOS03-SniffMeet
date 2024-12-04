//
//  HomeRouter.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

import UIKit 

protocol HomeRoutable: Routable {
    func showProfileEditView(homeView: any HomeViewable, userInfo: UserInfo)
    func showNotificationView(homeView: any HomeViewable)
    func showAlert(homeView: any HomeViewable, title: String, message: String)
    func transitionToMateListView(homeView: any HomeViewable)
}

final class HomeRouter: NSObject, HomeRoutable {
    func showProfileEditView(homeView: any HomeViewable, userInfo: UserInfo) {
        guard let homeView = homeView as? UIViewController else { return }
        let profileCreateViewController =
        ProfileEditRouter.createProfileEditModule(userInfo: userInfo)
        pushNoBottomBar(from: homeView, to: profileCreateViewController, animated: true)
    }
    func showNotificationView(homeView: any HomeViewable) {
        guard let homeView = homeView as? UIViewController else { return }
        let notificationViewController = NotificationListRouter.createNotificationListModule()
        push(from: homeView, to: notificationViewController, animated: true)
    }
    func showAlert(homeView: any HomeViewable, title: String, message: String) {
        guard let homeView = homeView as? UIViewController else { return }
        if let presentedVC = homeView.presentedViewController as? UIAlertController {
            presentedVC.dismiss(animated: false)
        }

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        homeView.present(alertVC, animated: true, completion: nil)
    }
    func transitionToMateListView(homeView: any HomeViewable) {
        guard let homeView = homeView as? UIViewController,
              let tabBarController = homeView.tabBarController else { return }
        tabBarController.selectedIndex = 1
    }
}
