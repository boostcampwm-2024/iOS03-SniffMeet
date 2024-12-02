//
//  RequestMateViewController.swift
//  SniffMeet
//
//  Created by 배현진 on 11/20/24.
//

import Combine
import UIKit

protocol RequestMateViewable: AnyObject {
    var presenter: RequestMatePresentable? { get set }
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
    private let profile: DogProfileDTO
    private var cancellables = Set<AnyCancellable>()

    init(profile: DogProfileDTO) {
        self.profile = profile
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureAttributes() {
        profileImageView.image = UIImage(data: profile.profileImage!)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.isUserInteractionEnabled = false
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
        zStackView.bringSubviewToFront(declineButton)
        zStackView.bringSubviewToFront(acceptButton)
        zStackView.isUserInteractionEnabled = true

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
            zStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            zStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            zStackView.heightAnchor.constraint(equalTo: view.heightAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            profileImageView.heightAnchor.constraint(equalTo: view.heightAnchor),
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
    override func bind() {
        bindDeclineButtonAction()
        bindAccepteButtonAction()
    }

    private func bindDeclineButtonAction() {
        declineButton.isHidden = false
        declineButton.publisher(event: .touchUpInside)
            .sink { [weak self] in
                self?.presenter?.closeTheView()
            }
            .store(in: &cancellables)
    }

    private func bindAccepteButtonAction() {
        acceptButton.isHidden = false
        acceptButton.publisher(event: .touchUpInside)
            .sink { [weak self] in
                Task {
                    await self?.presenter?.didTapAcceptButton(id: self?.profile.id ?? DogProfileDTO.example.id)
                }
            }
            .store(in: &cancellables)
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
