//
//  PaddingLabel.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/19/24.
//

import UIKit

final class PaddingLabel: UILabel {
    private let padding = LayoutConstant.edgePadding
    private var paddingType: PaddingType

    init(paddingType: PaddingType = .all) {
        self.paddingType = paddingType
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        self.paddingType = .all
        super.init(coder: coder)
    }
    override func drawText(in rect: CGRect) {
        var insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        switch paddingType {
        case .horizontal:
            insets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        case .vertical:
            insets = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        case .all:
            break
        }
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        switch paddingType {
        case .horizontal:
            return CGSize(width: size.width + padding * 2, height: size.height)
        case .vertical:
            return CGSize(width: size.width, height: size.height + padding * 2)
        case .all:
            return CGSize(width: size.width + padding * 2, height: size.height + padding * 2)
        }
    }
    override var bounds: CGRect {
        didSet {
            switch paddingType {
            case .horizontal:
                preferredMaxLayoutWidth = bounds.width - ( padding * 2 )
            case .vertical:
                preferredMaxLayoutWidth = bounds.width
            case .all:
                preferredMaxLayoutWidth = bounds.width - ( padding * 2 )
            }
        }
    }
    enum PaddingType {
        case horizontal
        case vertical
        case all
    }
}
