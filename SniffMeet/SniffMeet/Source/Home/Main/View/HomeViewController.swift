//
//  MainViewController.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/9/24.
//

import Combine
import UIKit

protocol HomeViewable: AnyObject {
    var presenter: (any HomePresentable)? { get }
}

final class HomeViewController: BaseViewController, HomeViewable {
    var presenter: (any HomePresentable)?
    private let profileCardView = ProfileCardView()
    private var startSessionButton: UIButton = PrimaryButton(title: Context.primaryButtonLabel)
    private var mpcManager: MPCManager?
    private var niManager: NIManager?
    private var cancellables = Set<AnyCancellable>()
    private var count: Int = 0
    var dogProfile: DogProfileDTO?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMPCManager()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
        navigationItem.title = Context.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    override func configureAttributes() {
        let notificationBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bell")?
                .withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(notificationBarButtonDidTap)
        )
        navigationItem.rightBarButtonItem = notificationBarButtonItem
    }
    override func configureHierachy() {
        [profileCardView, startSessionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: LayoutConstant.largeVerticalPadding
            ),
            profileCardView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: LayoutConstant.mediumVerticalPadding
            ),
            profileCardView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -LayoutConstant.mediumVerticalPadding
            ),
            profileCardView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -100
            ),
            startSessionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -LayoutConstant.mediumVerticalPadding
            ),
            startSessionButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.horizontalPadding
            ),
            startSessionButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.horizontalPadding
            )
        ])
    }
    override func bind() {
        presenter?.output.dogInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] dogInfo in
                self?.profileCardView.setName(name: dogInfo.name)
                self?.profileCardView.setKeywords(from: dogInfo.keywords.map{ $0.rawValue })
                if let profileImageData = dogInfo.profileImage,
                   let uiImage = UIImage(data: profileImageData) {
                    self?.profileCardView.setProfileImage(profileImage: uiImage)
                }
            }
            .store(in: &cancellables)

        mpcManager?.$paired
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaired in
                if 1...3 ~= self?.count ?? 0 {
                    self?.presenter?.changeIsPaired(with: isPaired)
                }
                self?.count += 1
            }
            .store(in: &cancellables)

        mpcManager?.receivedDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profile in
                SNMLogger.info("HomeViewController received data: \(profile)")
                self?.dogProfile = profile
            }
            .store(in: &cancellables)

        niManager?.isViewTransitioning
            .receive(on: RunLoop.main)
            .sink { [weak self] bool in
                guard let profile = self?.dogProfile else {
                    SNMLogger.error("No exist profile")
                    return
                }
                if bool {
                    SNMLogger.log("isViewTransitioning")
                    self?.presenter?.profileData(profile)
                }
            }
            .store(in: &cancellables)
        profileCardView.didTapEditButton
            .receive(on: RunLoop.main)
            .sink { [weak self] bool in
                if bool {
                    guard let userInfo = self?.presenter?.output.dogInfo.value else { return }
                    self?.presenter?.didTapEditButton(userInfo: userInfo)
                }     
        startSessionButton.publisher(event: .touchUpInside)
            .throttle(for: .seconds(EventConstant.throttleInterval),
                      scheduler: RunLoop.main,
                      latest: false)
            .sink {[weak self] _ in
                self?.mpcManager?.isAvailableToBeConnected = true
                self?.count = 1
            }
            .store(in: &cancellables)
    }
    @objc func notificationBarButtonDidTap() {
        presenter?.notificationBarButtonDidTap()
    }

    private func setupMPCManager() {
        mpcManager = MPCManager(yourName: String(UUID().uuidString.suffix(8)))
        niManager = NIManager(mpcManager: mpcManager!)
    }
}

// MARK: - HomeViewController+Context

extension HomeViewController {
    private enum Context {
        static let title: String = "SniffMeet"
        static let primaryButtonLabel: String = "메이트 연결하기"
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return FromTop2BottomPresentAnimator()
    }
}
