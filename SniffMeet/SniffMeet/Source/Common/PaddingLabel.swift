//
//  PaddingLabel.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/19/24.
//

import UIKit

final class AllPaddingLabel: UILabel {
    private let padding = LayoutConstant.edgePadding

    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        super.drawText(in: rect.inset(by: insets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding * 2, height: size.height + padding * 2)
    }
    override var bounds: CGRect {
        didSet { preferredMaxLayoutWidth = bounds.width - ( padding * 2 ) }
    }
}
