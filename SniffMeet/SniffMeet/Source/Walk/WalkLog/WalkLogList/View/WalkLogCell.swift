//
//  WalkLogCell.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import UIKit

final class WalkLogCell: UITableViewCell {
    private let profileImageView: UIImageView = UIImageView(frame: .zero)

    private let profileStackView: UIStackView = UIStackView()
    private let nickNameLabel: UILabel = UILabel()
    private let dateAndLocationLabel: UILabel = UILabel()

    private let walkLogStackView: UIStackView = UIStackView()

    private let distanceStackView: UIStackView = UIStackView()
    private let distanceTitleLabel: UILabel = UILabel()
    private let distanceLabel: UILabel = UILabel()

    private let stepStackView: UIStackView = UIStackView()
    private let stepTitleLabel: UILabel = UILabel()
    private let stepLabel: UILabel = UILabel()

    private let timeStackView: UIStackView = UIStackView()
    private let timeTitleLabel: UILabel = UILabel()
    private let timeLabel: UILabel = UILabel()

    private let walkLogImageView: UIImageView = UIImageView(frame: .zero)

    init(
        dogInfo: DogProfileDTO,
        walkLog: WalkLog,
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell(dogInfo: dogInfo)
        configureCell(walkLog: walkLog)
        configureAttributes()
        configureHierarchy()
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAttributes() {
        profileImageView.backgroundColor = SNMColor.subGray1
        profileImageView.image = UIImage(resource: .imagePlaceholder)
        profileImageView.layer.cornerRadius = Context.profileImageSize / 2
        profileImageView.clipsToBounds = true

        nickNameLabel.font = SNMFont.headline

        dateAndLocationLabel.font = SNMFont.caption2
        dateAndLocationLabel.textColor = SNMColor.text2

        walkLogStackView.spacing = 30
        profileStackView.axis = .vertical
        distanceStackView.axis = .vertical
        stepStackView.axis = .vertical
        timeStackView.axis = .vertical

        distanceTitleLabel.text = Context.distanceLabelTitle
        distanceTitleLabel.textAlignment = .center
        distanceTitleLabel.textColor = SNMColor.text2
        distanceTitleLabel.font = SNMFont.caption2
        distanceLabel.font = SNMFont.caption2
        distanceLabel.textAlignment = .center

        stepTitleLabel.text = Context.stepLabelTitle
        stepTitleLabel.textAlignment = .center
        stepTitleLabel.textColor = SNMColor.text2
        stepTitleLabel.font = SNMFont.caption2
        stepLabel.font = SNMFont.caption2
        stepLabel.textAlignment = .center

        timeTitleLabel.text = Context.timeLabelTitle
        timeTitleLabel.textAlignment = .center
        timeTitleLabel.textColor = SNMColor.text2
        timeTitleLabel.font = SNMFont.caption2
        timeLabel.font = SNMFont.caption2
        timeLabel.textAlignment = .center

        walkLogImageView.image = UIImage(resource: .imagePlaceholder)
    }
    private func configureHierarchy() {
        [nickNameLabel,
         dateAndLocationLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            profileStackView.addArrangedSubview($0)
        }
        [distanceTitleLabel,
         distanceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            distanceStackView.addArrangedSubview($0)
        }
        [stepTitleLabel,
         stepLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stepStackView.addArrangedSubview($0)
        }
        [timeTitleLabel,
         timeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            timeStackView.addArrangedSubview($0)
        }
        [distanceStackView,
         stepStackView,
         timeStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            walkLogStackView.addArrangedSubview($0)
        }

        [profileImageView,
         profileStackView,
         walkLogStackView,
         walkLogImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(
                equalToConstant: Context.profileImageSize
            ),
            profileImageView.heightAnchor.constraint(
                equalToConstant: Context.profileImageSize
            ),
            profileImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            profileImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),

            profileStackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileStackView.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor,
                constant: LayoutConstant.tagHorizontalSpacing
            ),
            profileStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            distanceStackView.heightAnchor.constraint(
                equalToConstant: SNMFont.caption.lineHeight * 2
            ),
            stepStackView.heightAnchor.constraint(
                equalToConstant: SNMFont.caption.lineHeight * 2
            ),
            timeStackView.heightAnchor.constraint(
                equalToConstant: SNMFont.caption.lineHeight * 2
            ),

            walkLogStackView.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor,
                constant: LayoutConstant.smallVerticalPadding
            ),
            walkLogStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            walkLogStackView.heightAnchor.constraint(
                equalToConstant: walkLogStackView.intrinsicContentSize.height
            ),
            
            walkLogImageView.topAnchor.constraint(
                equalTo: walkLogStackView.bottomAnchor,
                constant: LayoutConstant.smallVerticalPadding
            ),
            walkLogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            walkLogImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            walkLogImageView.heightAnchor.constraint(equalToConstant: 246)
        ])
    }
    func configureCell(walkLog: WalkLog) {
        distanceLabel.text = "\(walkLog.distance)"
        timeLabel.text = "\(walkLog.duration)"
        stepLabel.text = "\(100)"
        dateAndLocationLabel.text = "부천시 100213213"
    }
    func configureCell(dogInfo: DogProfileDTO) {
        if let profileImage = dogInfo.profileImage {
            profileImageView.image = UIImage(data: profileImage)
        }
        nickNameLabel.text = dogInfo.name
    }
}

extension WalkLogCell {
    static let identifier: String = String(describing: WalkLogCell.self)
}

// MARK: - WalkLogCell+Context

private extension WalkLogCell {
    enum Context {
        static let distanceLabelTitle: String = "거리"
        static let stepLabelTitle: String = "걸음 수"
        static let timeLabelTitle: String = "시간"
        static let profileImageSize: CGFloat = 58
    }
}
