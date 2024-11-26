//
//  MateListViewController.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/21/24.
//

import Combine
import UIKit

protocol MateListViewable: AnyObject {
    // var presenter: (any MateListPresentable)? { get }
}

final class MateListViewController: BaseViewController, MateListViewable {
    // var presenter: any MateListPresentable?
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureAttributes() {
        navigationItem.title = Context.title
        setTableView()
    }

    override func configureHierachy() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func configureConstraints() {
        let constraints = [
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func bind() {
//        presenter?.mates
//            .sink { [weak self] in
//                self?.updateTableView()
//            }
//            .store(in: &cancellables)
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifier.mateCellID)
        tableView.separatorStyle = .none
    }

    func updateTableView() {
        // 네트워크에서 mate를 다 불러오면 호출됩니다.
        // FIXME: Diffable data source
        tableView.reloadData()
    }
}

extension MateListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // presenter.mates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.mateCellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.image = .app // presenter.setCellImage?
        content.imageProperties.maximumSize = ItemSize.profileImageSize
        content.imageProperties.cornerRadius = ItemSize.profileImageCornerRadius
        content.text = "Mate" // presenter.mates[indexPath].name
        cell.contentConfiguration = content
        cell.accessoryView = createAccessoryButton()
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemSize.cellHeight
    }

    private func createAccessoryButton() -> UIButton {
        // 공용 뷰 컴포넌트가 아니라서 common에 분리하지 않았습니다.
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(origin: .zero, size: ItemSize.accessoryButtonSize)
        button.backgroundColor = SNMColor.mainBrown
        button.setTitle(Context.accessoryButtonLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
        return button
    }
}

// MARK: - MateListViewController+Context

extension MateListViewController {
    private enum Context {
        static let title = "메이트"
        static let primaryButtonLabel = "메이트 연결하기"
        static let accessoryButtonLabel = "산책 신청하기"
    }

    private enum Identifier {
        static let mateCellID = "mateCellID"
    }

    private enum ItemSize {
        static let profileImageSize = CGSize(width: 60, height: 60)
        static let profileImageCornerRadius: CGFloat = 30
        static let accessoryButtonSize = CGSize(width: 100, height: 30)
        static let cellHeight: CGFloat = 70
    }
}
