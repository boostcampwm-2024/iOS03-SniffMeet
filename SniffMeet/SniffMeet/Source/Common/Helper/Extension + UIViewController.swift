//
//  Extension + UIViewController.swift
//  SniffMeet
//
//  Created by sole on 11/27/24.
//

import UIKit

extension UIViewController {
    /// 현재 Scene에서 가장 앞에 presented 된 ViewController를 찾습니다.
    static var topMostViewController: UIViewController? {
        let base = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
            .first
        var current = base
        while let presented = current?.presentedViewController {
            current = presented
        }
        return current
    }
}
