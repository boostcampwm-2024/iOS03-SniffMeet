//
//  SNMColor.swift
//  SniffMeet
//
//  Created by sole on 11/11/24.
//

import UIKit

enum SNMColor {
    static let mainNavy: UIColor = UIColor.mainNavy
    static let mainWhite: UIColor = UIColor.mainWhite
    static let mainBrown: UIColor = UIColor.mainBrown
    static let mainBeige: UIColor = UIColor.mainBeige
    static let subGray1: UIColor = UIColor.subGray1
    static let subGray2: UIColor = UIColor(hex: 0xC0C0C0)
    static let text1: UIColor = UIColor(hex: 0xCCD7DC)
    static let disabledGray: UIColor = UIColor(hex: 0xE6EAEC)
    static let warningRed: UIColor = UIColor(hex: 0xF64545)
    static let cardIconButtonBackground: UIColor = UIColor(hex: 0xECECEC, alpha: 0.87)
}

// MARK: - UIColor+init

extension UIColor {
    /// hex 값은 0x000000 (0x 뒤 여섯자리(0-F) 값)과 같은 형식만 넣어야합니다. 예시: 0xC0C0C, 0xECECEC, 0xF64545
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            alpha: alpha
        )
    }
}
