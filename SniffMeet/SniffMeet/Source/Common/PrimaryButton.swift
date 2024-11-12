//
//  PrimaryButton.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/7/24.
//

import UIKit

final class PrimaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupConfiguration(title: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupConfiguration(title: String) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .mainNavy
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 16,
            bottom: 20,
            trailing: 16
        )
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(
                [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold)]
            )
        )
        
        let handler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = SNMColor.disabledGray
            case .normal:
                button.configuration?.background.backgroundColor = SNMColor.mainNavy
            default:
                break
            }
        }

        self.configuration = configuration
        self.configurationUpdateHandler = handler
    }
}
