//
//  ProcessedWalkViewController.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/19/24.
//

import Combine
import UIKit

protocol ProcessedWalkViewable: AnyObject {
    var presenter: (any ProcessedWalkPresentable)? { get set }

    func showRequestDetail(isAccepted: Bool, request: WalkRequestDetail)
}

final class ProcessedWalkViewController: BaseViewController, ProcessedWalkViewable {
    var presenter: (any ProcessedWalkPresentable)?
    private var cancellables: Set<AnyCancellable> = []
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = SNMColor.mainNavy
        return button
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = SNMFont.title3
        label.textColor = SNMColor.mainNavy
        label.textAlignment = .center
        return label
    }()
    private var profileView: ProfileView = {
        let view = ProfileView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    private var locationView = LocationSelectionView()
    private var messageLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = SNMColor.subGray1
        label.textColor = SNMColor.subBlack1
        label.font = SNMFont.body
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 4
        return label
    }()
    private var confirmButton = PrimaryButton(title: Context.confirmButtonTitle)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    override func configureAttributes() {
        profileView.configure(
            name: UserInfo.example.name,
            keywords: UserInfo.example.keywords.map { $0.rawValue }
        )
        titleLabel.text = (presenter?.noti.category == .walkAccepted) ?
        Context.acceptedRequestTitle : Context.declinedRequestTitle
        messageLabel.text = Context.defaultMessageContent
    }
    override func configureHierachy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [scrollView, contentView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [titleLabel,
        dismissButton,
         profileView,
         locationView,
         messageLabel,
         confirmButton].forEach
        {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo:
                                                scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant:
                                                    max(650, view.bounds.size.height * 0.8))
        ])

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: LayoutConstant.regularVerticalPadding),
            dismissButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding),
            dismissButton.heightAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            dismissButton.widthAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: LayoutConstant.xlargeVerticalPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            profileView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            profileView.widthAnchor.constraint(equalTo: profileView.heightAnchor),
            locationView.topAnchor.constraint(
                equalTo: profileView.bottomAnchor,
                constant: LayoutConstant.mediumVerticalPadding),
            locationView.heightAnchor.constraint(equalToConstant: 25),
            messageLabel.topAnchor.constraint(
                equalTo: locationView.bottomAnchor,
                constant: LayoutConstant.regularVerticalPadding),
            messageLabel.bottomAnchor.constraint(
                equalTo: confirmButton.topAnchor,
                constant: -LayoutConstant.regularVerticalPadding
            ),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -LayoutConstant.xlargeVerticalPadding),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        [locationView, messageLabel, confirmButton].forEach {
            $0.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstant.smallHorizontalPadding).isActive = true
            $0.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding).isActive = true
        }
    }
    override func bind() {
        presenter?.output.locationLabel
            .receive(on: RunLoop.main)
            .sink { [weak self] locationLabel in
                guard let locationLabel else { return }
                self?.locationView.setAddress(address: locationLabel)
            }
            .store(in: &cancellables)

        dismissButton.publisher(event: .touchUpInside)
            .receive(on: RunLoop.main)
            .sink {[weak self] _ in
                guard let self else { return }
                presenter?.dismissView()
            }
            .store(in: &cancellables)

        confirmButton.publisher(event: .touchUpInside)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.presenter?.dismissView()
            }
            .store(in: &cancellables)

        presenter?.output.profileImage
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.profileView.configureImage(with: image)
            }
            .store(in: &cancellables)

        locationView.tapPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.presenter?.didTapLocationViewButton()
            }
            .store(in: &cancellables)
    }
}

// MARK: - ProcessedWalkViewController+Context

private extension ProcessedWalkViewController {
    enum Context {
        static let acceptedRequestTitle: String = "산책 요청이 수락됐어요!"
        static let declinedRequestTitle: String = "산책 요청이 거절됐어요."
        static let confirmButtonTitle: String = "확인"
        static let defaultMessageContent: String = "HomeView에서 dogInfo의 변경을 알아야 하더라구요. Presenter에서 HomePresenterOutput 프로토콜을 채택하도록 설정해줬습니다."
    }
}

// MARK: - ProcessedWalkViewController+Viewable method

extension ProcessedWalkViewController {
    func showRequestDetail(isAccepted: Bool, request: WalkRequestDetail) {
        titleLabel.text = isAccepted ?
        Context.acceptedRequestTitle : Context.declinedRequestTitle
        messageLabel.text = request.message
        profileView.configure(
            name: request.mate.name,
            keywords: request.mate.keywords.map { $0.rawValue }
        )
    }
}
