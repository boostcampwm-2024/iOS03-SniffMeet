//
//  Extension + Navigation.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/7/24.
//
import UIKit

extension UINavigationItem {
    
    func setupConfiguration(title: String) {
        self.title = title
        
        guard let navyColor = UIColor(named: "MainNavy") else { return }
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: navyColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: navyColor]

        standardAppearance = appearance
        scrollEdgeAppearance = appearance
    }
}

