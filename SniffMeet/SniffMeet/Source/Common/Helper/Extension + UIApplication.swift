//
//  Extension + UIAplplication.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/3/24.
//
import UIKit

extension UIApplication {
  static var screenSize: CGSize {
    guard let windowScene = shared.connectedScenes.first as? UIWindowScene else {
      return UIScreen.main.bounds.size
    }
    return windowScene.screen.bounds.size
  }
  
  static var screenHeight: CGFloat {
    return screenSize.height
  }
  
  static var screenWidth: CGFloat {
    return screenSize.width
  }
}
