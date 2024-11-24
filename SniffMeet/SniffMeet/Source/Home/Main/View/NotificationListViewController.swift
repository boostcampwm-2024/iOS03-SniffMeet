//
//  NotificationListViewController.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import UIKit

final class NotificationListViewController: BaseViewController {
    private let notificationTableView: UITableView = UITableView()

    override func configureAttributes() {
        let chevronImage = UIImage(systemName: "chevron.left")
        let trashCanImage = UIImage(systemName: "trash")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: chevronImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: trashCanImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = SNMColor.mainNavy
        navigationItem.rightBarButtonItem?.tintColor = SNMColor.mainNavy
        navigationItem.title = Context.navigationTitle

        notificationTableView.dataSource = self
        notificationTableView.delegate = self
        notificationTableView.separatorInset = UIEdgeInsets(
            top: 2,
            left: LayoutConstant.horizontalPadding,
            bottom: 2,
            right: LayoutConstant.horizontalPadding
        )
    }
    override func configureHierachy() {
        [notificationTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            notificationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notificationTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            notificationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

private extension NotificationListViewController {
    enum Context {
        static let navigationTitle: String = "알림"
    }
}

// MARK: - NotificationListViewController+UITableView DataSoure, Delegate

extension NotificationListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        // FIXME: 실제 데이터로 변경 필요
        10
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        // FIXME: 실제 데이터로 변경 필요
        let notification: Notification = Notification(
            section: "산책 요청",
            description: "허거덩 친구가 산책 요청을 보냈어요",
            date: "14시간 전"
        )
        return NotificationCell(
            notification: notification,
            style: .default,
            reuseIdentifier: NotificationCell.identifier
        )
    }
}

extension NotificationListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        68
    }
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: 산책 요청 뷰 띄우기 
    }
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, completion in
            self?.deleteNotification(index: indexPath.row)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    private func deleteNotification(index: Int) {
        // TODO: 삭제 로직 구현 필요
        SNMLogger.print("Delete notification at \(index)")
    }
}
