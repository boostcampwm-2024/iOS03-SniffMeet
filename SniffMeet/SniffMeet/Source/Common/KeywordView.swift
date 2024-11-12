//
//  KeywordView.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/7/24.
//
import UIKit

final class KeywordView: UILabel {
    private var insets = UIEdgeInsets(
        top: Context.verticalPadding,
        left: Context.horizontalPadding,
        bottom: Context.verticalPadding,
        right: Context.horizontalPadding
    )
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + insets.left + insets.right,
            height: size.height + insets.top + insets.bottom
        )
    }

    init(title: String) {
        super.init(frame: .zero)
        setupConfiguration(title: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: insets)
        super.drawText(in: insetRect)
    }

    private func setupConfiguration(title: String) {
        text = "#" + title
        font = UIFont.systemFont(ofSize: 14)
        layer.cornerRadius = Context.cornerRadius
        layer.masksToBounds = true
        self.backgroundColor = SNMColor.white

    }
}
extension KeywordView {
    private enum Context {
        static let verticalPadding: CGFloat = 4
        static let horizontalPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 13
    }
}
