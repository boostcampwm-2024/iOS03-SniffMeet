//
//  PrimaryButton.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/7/24.
//

import Combine
import UIKit

final class AddMateButton: UIButton {
    enum ButtonState: String {
        case normal
        case connecting
        case success
        case failure
    }

    var buttonState: ButtonState = .normal {
        didSet {
            switch buttonState {
            case .normal:
                configuration?.background.backgroundColor = SNMColor.mainBeige
                configuration?.title = "친구를 찾아보세요"
                configuration?.image = UIImage(systemName: "person.2.badge.plus.fill")
            case .connecting:
                configuration?.background.backgroundColor = UIColor.systemGray
                configuration?.title = "연결 중..."
                configuration?.image = UIImage(systemName: "wifi")
            case .success:
                configuration?.background.backgroundColor = UIColor.systemGreen
                configuration?.title = "성공"
                configuration?.image = UIImage(systemName: "checkmark.circle")
            case .failure:
                configuration?.background.backgroundColor = UIColor.systemGreen
                configuration?.title = "실패"
                configuration?.image = UIImage(systemName: "x.circle")
            }
        }
    }

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
        configuration.image = UIImage(systemName: "person.2.badge.plus.fill")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = SNMColor.mainNavy
        configuration.baseForegroundColor = SNMColor.white
        configuration.cornerStyle = .capsule
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
        self.configuration = configuration
    }
}
