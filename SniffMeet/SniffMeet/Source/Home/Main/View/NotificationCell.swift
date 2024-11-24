//
//  NotificationCell.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import UIKit

final class NotificationCell: UITableViewCell {
    private let notificationStackView: UIStackView = UIStackView()
    private let sectionLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()

    init(
        notification: Notification,
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAttributes()
        configureHierarchy()
        configureConstraints()
        configure(notification: notification)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAttributes() {
        notificationStackView.axis = .vertical
        notificationStackView.spacing = 2
        notificationStackView.isLayoutMarginsRelativeArrangement = true
        notificationStackView.layoutMargins = UIEdgeInsets(
            top: LayoutConstant.xsmallVerticalPadding,
            left: LayoutConstant.horizontalPadding,
            bottom: LayoutConstant.xsmallVerticalPadding,
            right: LayoutConstant.horizontalPadding
        )
        sectionLabel.font = SNMFont.caption
        sectionLabel.textColor = SNMColor.text3
        dateLabel.font = SNMFont.caption
        dateLabel.textColor = SNMColor.text3
    }
    private func configureHierarchy() {
        [notificationStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [sectionLabel,
         descriptionLabel,
         dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            notificationStackView.addArrangedSubview($0)
        }
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            notificationStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            notificationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            notificationStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            notificationStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            )
        ])
    }
    
    func configure(notification: Notification) {
        sectionLabel.text = notification.section
        descriptionLabel.text = notification.description
        dateLabel.text = notification.date
    }
}

extension NotificationCell {
    static let identifier: String = String(describing: NotificationCell.self)
}
