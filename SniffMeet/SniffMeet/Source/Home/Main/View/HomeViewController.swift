//
//  MainViewController.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/9/24.
//

import Combine
import UIKit

final class HomeViewController: UIViewController {
    let profileCardView = ProfileCardView()

    private var startSessionButton: UIButton = PrimaryButton(title: "메이트 연결하기")
    private var mpcManager: MPCManager?
    private var niManager: NIManager?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // presenter.viewDidLoad()
        setupNavigationItem()
        setupLayouts()
        view.backgroundColor = .systemBackground
        setupMPCManager()
        setupBindings()
        startSessionButton.addTarget(self, action: #selector(goToStartSession), for: .touchUpInside)
    }

    func setupNavigationItem() {
        navigationItem.title = "SniffMEET"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        let notificationBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bell")?
                .withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(notificationBarButtonDidTap)
        )
        navigationItem.rightBarButtonItem = notificationBarButtonItem
    }
    func setupLayouts() {
        profileCardView.translatesAutoresizingMaskIntoConstraints = false
        startSessionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileCardView)
        view.addSubview(startSessionButton)
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 30
            ),
            profileCardView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),
            profileCardView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            profileCardView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -100
            ),
            startSessionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
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
    @objc func notificationBarButtonDidTap() {
        // presenter.notificationBarButtonDidTap
        // 혹은 action을 nil로 하고 아예 .touchUpInside 사용해서 Combine으로 처리할 수 있지 않을까요
    }

    @objc func goToStartSession() {
        mpcManager?.isAvailableToBeConnected = true
        mpcManager?.browser.startBrowsing()
        mpcManager?.advertiser.startAdvertising()
    }

    private func setupMPCManager() {
        mpcManager = MPCManager(yourName: UIDevice.current.name)
        niManager = NIManager(mpcManager: mpcManager!)
    }

    private func setupBindings() {
        mpcManager?.$paired
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaired in
                if isPaired {
                    self?.showAlert(title: "Connected", message: "Successfully connected to a peer.")
                } else {
                    self?.showAlert(title: "Disconnected", message: "Connection to peer lost.")
                }
            }
            .store(in: &cancellables)
    }

    private func showAlert(title: String, message: String) {
        if let presentedVC = presentedViewController as? UIAlertController {
            presentedVC.dismiss(animated: false)
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
