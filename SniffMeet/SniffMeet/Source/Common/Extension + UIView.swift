//
//  Extension + UIView.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/9/24.
//

import UIKit

extension UIView {
    func makeViewCircular() {
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}
