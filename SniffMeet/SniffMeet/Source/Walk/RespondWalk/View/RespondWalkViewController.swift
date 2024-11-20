//
//  RespondWalkViewController.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/19/24.
//
import Combine
import UIKit

protocol RespondWalkViewable: AnyObject {
    var presenter: RespondWalkPresentable? { get set }
    
    func showRequestDetail(request: WalkRequest)
    func showTimeOut()
    func showError()
}

final class RespondWalkViewController: BaseViewController, RespondWalkViewable {
    var presenter: (any RespondWalkPresentable)?
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
        label.text = Context.mainTitle
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
    private var messageLabel: AllPaddingLabel = {
        let label = AllPaddingLabel()
        label.backgroundColor = SNMColor.subGray1
        label.textColor = SNMColor.subBlack1
        label.font = SNMFont.body
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 4
        return label
    }()
    private var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "60" + Context.warningTitle
        label.font = SNMFont.caption
        label.textColor = SNMColor.black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private var acceptButton = PrimaryButton(title: Context.acceptButtonTitle)
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    override func configureAttributes() {
        profileView.configure(dog: Dog(name: "진돌이", age: 12, size: .big, keywords: [.energetic, .friendly], nickname: "지성", profileImage: UIImage.imagePlaceholder.pngData()))
        messageLabel.text = "HomeView에서 dogInfo의 변경을 알아야 하더라구요. Presenter에서 HomePresenterOutput 프로토콜을 채택하도록 설정해줬습니다."
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
         warningLabel,
         acceptButton].forEach
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
            contentView.heightAnchor.constraint(equalToConstant: 650)
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
            warningLabel.topAnchor.constraint(
                equalTo: messageLabel.bottomAnchor,
                constant: LayoutConstant.mediumVerticalPadding),
            warningLabel.bottomAnchor.constraint(
                equalTo: acceptButton.topAnchor,
                constant: -LayoutConstant.smallVerticalPadding),
            warningLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            acceptButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -LayoutConstant.xlargeVerticalPadding),
            acceptButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        [locationView, messageLabel, warningLabel, acceptButton].forEach {
            $0.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstant.smallHorizontalPadding).isActive = true
            $0.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding).isActive = true
        }
    }
}

private extension RespondWalkViewController {
    enum Context {
        static let mainTitle: String = "산책 요청이 도착했어요!"
        static let locationGuideTitle: String = "산책 시작 장소"
        static let messagePlaceholder: String = "간단한 요청 메세지를 작성해주세요."
        static let acceptButtonTitle: String = "산책 요청 수락하기"
        static let warningTitle: String = "초 안에 요청을 수락하지 않으면 자동으로 거절 처리돼요."
        static let characterCountLimit: Int = 100
    }
    
    func setButtonActions() {
        dismissButton.addAction(UIAction(handler: {[weak self] _ in
            self?.presenter?.dismissView()
        }), for: .touchUpInside)
        
    }
}


// MARK: - RespondWalkViewable
extension RespondWalkViewController {
    func showRequestDetail(request: WalkRequest) {
        messageLabel.text = request.message
        locationView.setAddress(address: request.address.location)
        profileView.configure(dog: request.dog)
    }
    
    func showTimeOut() {
        
    }
    func showError() {
        
    }
}
