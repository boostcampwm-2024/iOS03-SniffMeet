//
//  HomeRouter.swift
//  SniffMeet
//
//  Created by sole on 11/18/24.
//

import UIKit 

protocol HomeRoutable: Routable {
    func showProfileEditView(homeView: any HomeViewable)
    func showNotificationView(homeView: any HomeViewable)
    func showAlert(homeView: any HomeViewable, title: String, message: String)
    func showMateRequestView(homeView: any HomeViewable, data: DogProfileInfo)
}

final class HomeRouter: NSObject, HomeRoutable {
    func showProfileEditView(homeView: any HomeViewable) {
        // TODO: ProfileEditViewController로 교체 필요
        guard let homeView = homeView as? UIViewController else { return }
        push(from: homeView, to: ProfileInputViewController(), animated: true)
    }
    func showNotificationView(homeView: any HomeViewable) {
        // TODO: NotificationViewController로 교체 필요 
        guard let homeView = homeView as? UIViewController else { return }
        push(from: homeView, to: BaseViewController(), animated: true)
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
    func showMateRequestView(homeView: any HomeViewable, data: DogProfileInfo) {
        guard let homeView = homeView as? UIViewController else { return }
        let requestMateViewController = RequestMateViewController(profile: data)
        requestMateViewController.modalPresentationStyle = .fullScreen
        
        if let homeView = homeView as?  UIViewControllerTransitioningDelegate {
            requestMateViewController.transitioningDelegate = homeView
        }
        present(from: homeView, with: requestMateViewController, animated: true)
    }
}
