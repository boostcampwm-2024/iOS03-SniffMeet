//
//  BasicTextField.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/7/24.
//

import UIKit

final class InputTextField: UITextField {
    private let padding = UIEdgeInsets(top: Context.verticalPadding,
                                       left: Context.horizontalPadding,
                                       bottom: Context.verticalPadding,
                                       right: Context.horizontalPadding)
    init(placeholder: String) {
        super.init(frame: .zero)
        setupConfiguration(placeholder: placeholder)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setupConfiguration(placeholder: String) {
        backgroundColor = SNMColor.subGray1
        self.placeholder = placeholder
        borderStyle = .none
        layer.cornerRadius = Context.cornerRadius
        clearButtonMode = .always
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension InputTextField {
    private enum Context {
        static let verticalPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 10
    }
}
