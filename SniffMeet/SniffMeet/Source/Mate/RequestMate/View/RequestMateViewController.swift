//
//  RequestMateViewController.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import UIKit

protocol RequestMateViewable: AnyObject {
    func updateView(with profile: DogProfileInfo)
}

final class RequestMateViewController: BaseViewController, RequestMateViewable {
    var presenter: RequestMatePresentable?

    private var zStackView = UIView()
    private var profileImageView = UIImageView()
    private var nameLabel = UILabel()
    private var keywordStackView = UIStackView()
    private var declineConfig = UIButton.Configuration.filled()
    private var declineButton: UIButton = UIButton(type: .system)
    private var acceptButton = PrimaryButton(title: Context.acceptTitle)
    private var keywords: [Keyword] = []
    private let profile: DogProfileInfo

    init(profile: DogProfileInfo) {
        self.profile = profile
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
    }

    override func configureAttributes() {
//        let placeholderImage = UIImage(named: "placeholder")
//        profileImageView.image = UIImage(data: profile.profileImage!)
        profileImageView.image = UIImage(named: "placeholder")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = profile.name
        nameLabel.textColor = SNMColor.white
        nameLabel.font = SNMFont.title1
        keywordStackView.axis = .horizontal
        keywordStackView.spacing = Context.keywordsStackViewSpacing
        keywordStackView.translatesAutoresizingMaskIntoConstraints = false
        declineConfig.baseBackgroundColor = SNMColor.disabledGray
        declineConfig.baseForegroundColor = SNMColor.mainNavy
        declineConfig.cornerStyle = .large
        declineConfig.contentInsets = NSDirectionalEdgeInsets(
            top: Context.buttonContentVerticalInsets,
            leading: Context.buttonContentHorizontalInsets,
            bottom: Context.buttonContentVerticalInsets,
            trailing: Context.buttonContentHorizontalInsets
        )
        declineConfig.attributedTitle = AttributedString(
            Context.declineTitle,
            attributes: AttributeContainer(
                [.font: SNMFont.callout2]
            )
        )
        declineButton = UIButton(configuration: declineConfig)
    }

    override func configureHierachy() {
        keywords = profile.keywords
        for keyword in keywords {
            let keywordView = KeywordView(title: keyword.rawValue)
            keywordStackView.addArrangedSubview(keywordView)
        }

        zStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(zStackView)
        zStackView.addSubview(profileImageView)

        [profileImageView,
         nameLabel,
         keywordStackView,
         declineButton,
         acceptButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            zStackView.addSubview($0)
        }
    }

    override func configureConstraints() {
        let constraints = [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameLabel.bottomAnchor.constraint(
                equalTo: keywordStackView.topAnchor,
                constant: -LayoutConstant.smallVerticalPadding
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            keywordStackView.bottomAnchor.constraint(
                equalTo: declineButton.topAnchor,
                constant: -LayoutConstant.mediumVerticalPadding
            ),
            keywordStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            declineButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -LayoutConstant.xlargeVerticalPadding
            ),
            declineButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            acceptButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -LayoutConstant.xlargeVerticalPadding
            ),
            acceptButton.leadingAnchor.constraint(
                equalTo: declineButton.trailingAnchor,
                constant: LayoutConstant.smallVerticalPadding
            ),
            acceptButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.horizontalPadding
            ),
            acceptButton.widthAnchor.constraint(equalTo: declineButton.widthAnchor, multiplier: Context.multiplier)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    override func bind() {}

    func updateView(with profile: DogProfileInfo) {
        if let profileImageData = profile.profileImage {
            let uiImage = UIImage(data: profileImageData)
            profileImageView.image = uiImage
        }
        nameLabel.text = profile.name
        keywords = profile.keywords
    }
}

private extension RequestMateViewController {
    enum Context {
        static let acceptTitle: String = "요청 수락"
        static let declineTitle: String = "요청 거절"
        static let keywordsStackViewSpacing: CGFloat = 8
        static let buttonContentHorizontalInsets: CGFloat = 16
        static let buttonContentVerticalInsets: CGFloat = 20
        static let multiplier: CGFloat = 2.5
    }
}
