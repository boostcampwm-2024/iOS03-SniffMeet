//
//  HashTagButton.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/7/24.
//

import UIKit

final class KeywordButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupConfiguration(title: title)
        addAction(UIAction { [weak self] _ in self?.isSelected.toggle()}, for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupConfiguration(title: String) {
        var configuration = UIButton.Configuration.filled()
        let handler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.baseBackgroundColor = SNMColor.mainBrown
            case .normal:
                button.configuration?.baseBackgroundColor = SNMColor.disabledGray
            default:
                break
            }
        }
        configuration.title = title
        configuration.baseForegroundColor = SNMColor.white
        configuration.baseForegroundColor = SNMColor.black
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 6,
            leading: 8,
            bottom: 6,
            trailing: 8
        )
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(
                [.font: UIFont.systemFont(ofSize: 12.0, weight: .regular)]
            )
        )

        self.configuration = configuration
        self.configurationUpdateHandler = handler
    }
}
