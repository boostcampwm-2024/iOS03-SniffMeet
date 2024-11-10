//
//  MainViewController.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/9/24.
//

import UIKit

final class HomeView: UIViewController {
    let profileCard = ProfileCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // presenter.viewDidLoad()
        setupNavigationItem()
        setupLayouts()
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
        profileCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileCard)
        NSLayoutConstraint.activate([
            profileCard.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 30
            ),
            profileCard.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 24
            ),
            profileCard.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            profileCard.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -30
            )
        ])
    }
    @objc func notificationBarButtonDidTap() {
        // presenter.notificationBarButtonDidTap
        // 혹은 action을 nil로 하고 아예 .touchUpInside 사용해서 Combine으로 처리할 수 있지 않을까요
    }
}
