//
//  NotificationListViewController.swift
//  SniffMeet
//
//  Created by sole on 11/24/24.
//

import Combine
import UIKit

protocol NotificationListViewable: AnyObject {
    var presenter: (any NotificationListPresentable)? { get set }
}

final class NotificationListViewController: BaseViewController, NotificationListViewable {
    var presenter: (any NotificationListPresentable)?
    var cancellables: Set<AnyCancellable> = []
    private let notificationTableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func configureAttributes() {
        let chevronImage = UIImage(systemName: Context.chevronImageName)
        let trashCanImage = UIImage(systemName: Context.trashcanImageName)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: chevronImage,
            style: .plain,
            target: self,
            action: #selector(didTapDismissButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: trashCanImage,
            style: .plain,
            target: self,
            action: #selector(didTapTrashcanButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = SNMColor.mainNavy
        navigationItem.rightBarButtonItem?.tintColor = SNMColor.mainNavy
        navigationItem.title = Context.navigationTitle
        navigationItem.largeTitleDisplayMode = .never

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
    override func bind() {
        presenter?.output.notificationList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.notificationTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc func didTapDismissButton() {
        presenter?.didTapDismissButton()
    }
    @objc func didTapTrashcanButton() {
        // TODO: 모든 알림 삭제 필요
    }
}

// MARK: - NotificationListViewController+Context

private extension NotificationListViewController {
    enum Context {
        static let navigationTitle: String = "알림"
        static let chevronImageName: String = "chevron.left"
        static let trashcanImageName: String = "trash"
        static let trashFillImageName: String = "trash.fill"
    }
}

// MARK: - NotificationListViewController+UITableView DataSoure, Delegate

extension NotificationListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter?.output.notificationList.value.count ?? 0
    }
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let datasource: [WalkNoti] = presenter?.output.notificationList.value ?? []
        let cell: NotificationCell = notificationTableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier
        ) as? NotificationCell ?? NotificationCell(
            style: .default,
            reuseIdentifier: NotificationCell.identifier
        )
        let selectedData: WalkNoti = datasource[indexPath.row]
        cell.configure(
            section: selectedData.category.label,
            description: selectedData.senderName + selectedData.category.description,
            dateString: "\(selectedData.createdAt?.hoursDifferenceFromNow() ?? 14)시간 전"
        )
        return cell
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
        presenter?.didTapNotificationCell(index: indexPath.row)
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
        deleteAction.image = UIImage(systemName: Context.trashFillImageName)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    private func deleteNotification(index: Int) {
        presenter?.didDeleteNotificationCell(index: index)
    }
}
