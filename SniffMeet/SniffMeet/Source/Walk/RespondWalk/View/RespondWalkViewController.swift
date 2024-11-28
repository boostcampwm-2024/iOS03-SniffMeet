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
    func showError()
    func startTimer(countDownValue: Int)
}

final class RespondWalkViewController: BaseViewController, RespondWalkViewable {
    var presenter: (any RespondWalkPresentable)?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var timerPublisher: AnyPublisher<Int, Never>?
    private var cancellables: Set<AnyCancellable> = []
    private var isTimedOut: Bool = false
    
    private var declineAlert = UIAlertController(title: "요청 수락 거절",
                                     message: "해당 창을 닫으면 산책 요청이 자동으로 거절 처리돼요. 창을 닫으시겠어요?",
                                     preferredStyle: .alert)
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
    private var timeLimitLabel: UILabel = {
        let label = UILabel()
        label.font = SNMFont.caption
        label.text = "   " + Context.remainingTimeLimitTitle
        label.textColor = SNMColor.black
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    private var submitButton = PrimaryButton(title: Context.abledSubmitButtonTitle)
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    override func configureAttributes() {
        profileView.configure(
            name: UserInfo.example.name,
            keywords: UserInfo.example.keywords.map { $0.rawValue }
        )
        messageLabel.text = "HomeView에서 dogInfo의 변경을 알아야 하더라구요. Presenter에서 HomePresenterOutput 프로토콜을 채택하도록 설정해줬습니다."
        
        submitButton.setTitle(Context.abledSubmitButtonTitle, for: .normal)
        submitButton.setTitle(Context.disabledSubmitButtonTitle, for: .disabled)
        
        let acceptAction = UIAlertAction(title: "거절하기", style: .destructive) {[weak self] _ in
            self?.presenter?.respondWalkRequest(isAccepted: false)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        declineAlert.addAction(acceptAction)
        declineAlert.addAction(cancelAction)
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
         timeLimitLabel,
         submitButton].forEach
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
            timeLimitLabel.topAnchor.constraint(
                equalTo: messageLabel.bottomAnchor,
                constant: LayoutConstant.mediumVerticalPadding),
            timeLimitLabel.bottomAnchor.constraint(
                equalTo: submitButton.topAnchor,
                constant: -LayoutConstant.smallVerticalPadding),
            timeLimitLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -LayoutConstant.xlargeVerticalPadding),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        [locationView, messageLabel, timeLimitLabel, submitButton].forEach {
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
                if !isTimedOut {
                    self.present(declineAlert, animated: true)
                } else {
                    presenter?.dismissView()
                }
            }
            .store(in: &cancellables)
        
        submitButton.publisher(event: .touchUpInside)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.presenter?.respondWalkRequest(isAccepted: true)
            }
            .store(in: &cancellables)
        
        presenter?.output.profileImage
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                self?.profileView.configureImage(with: image)
            }
            .store(in: &cancellables)
    }
}

private extension RespondWalkViewController {
    enum Context {
        static let mainTitle: String = "산책 요청이 도착했어요!"
        static let locationGuideTitle: String = "산책 시작 장소"
        static let messagePlaceholder: String = "간단한 요청 메세지를 작성해주세요."
        static let abledSubmitButtonTitle: String = "산책 요청 수락하기"
        static let disabledSubmitButtonTitle: String = "다음 기회에"
        static let remainingTimeLimitTitle: String = "초 안에 요청을 수락하지 않으면 자동으로 거절 처리돼요."
        static let timeoutTitle: String = "수락 제한 시간(60초) 초과되어 자동 거절처리 됐습니다."
        static let characterCountLimit: Int = 100
    }
}


// MARK: - RespondWalkViewable
extension RespondWalkViewController {
    func showRequestDetail(request: WalkRequest) {
        messageLabel.text = request.message
        locationView.setAddress(address: request.address.location)
        profileView.configure(
            name: request.mate.name,
            keywords: request.mate.keywords.map { $0.rawValue }
        )
    }
    func showError() {
        
    }
    func startTimer(countDownValue: Int) {
        timerPublisher = Publishers.Merge(
            Just(countDownValue), // 즉시 첫 값 발행
            Timer.publish(every: 1.0, on: RunLoop.main, in: RunLoop.Mode.common)
                .autoconnect()
                .scan(countDownValue) { current, _ in
                    max(current - 1, 0)
                }
        )
        .prefix(while: { $0 >= 0 }) // 값이 0일 때까지 이벤트 발행
        .eraseToAnyPublisher()
        
        timerPublisher?.sink { [weak self] value in
            guard let self else { return }
            self.timeLimitLabel.text = String(value) + Context.remainingTimeLimitTitle
            if value == 0 {
                self.timeLimitLabel.text = Context.timeoutTitle
                self.submitButton.isEnabled = false
                self.isTimedOut = true
            }
        }.store(in: &cancellables)
    }
}
