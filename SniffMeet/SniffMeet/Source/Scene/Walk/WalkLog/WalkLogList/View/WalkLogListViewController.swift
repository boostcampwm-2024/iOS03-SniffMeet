//
//  WalkLogListViewController.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import UIKit

final class WalkLogListViewController: BaseViewController {
    private let walkLogTableView: UITableView = UITableView()

    override func configureAttributes() {
        walkLogTableView.dataSource = self
        walkLogTableView.delegate = self
        walkLogTableView.separatorInset = .zero
    }
    override func configureHierachy() {
        [walkLogTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            walkLogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            walkLogTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            walkLogTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            walkLogTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - WalkLogListViewController+UITableView DataSource, Delegate

extension WalkLogListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        3
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        // FIXME: 실제 데이터로 변경 필요
        WalkLogCell(
            dogInfo: .init(
            id: UUID(uuidString: "") ?? DogProfileDTO.example.id,
            name: "후추추",
            keywords: [],
            profileImage: nil
            ),
            walkLog: .init(
                step: 100,
                distance: 1002.2,
                startDate: .now,
                endDate: .now,
                image: nil
            ),
            style: .default,
            reuseIdentifier: WalkLogCell.identifier
        )
    }
}

extension WalkLogListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        393
    }
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
