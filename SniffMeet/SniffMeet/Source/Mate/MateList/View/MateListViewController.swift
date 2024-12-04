//
//  MateListViewController.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/21/24.
//

import Combine
import UIKit

protocol MateListViewable: AnyObject {
    var presenter: (any MateListPresentable)? { get set }
}

final class MateListViewController: BaseViewController, MateListViewable {
    var presenter: (any MateListPresentable)?
    var imageDataSource: [Int: Data] = [:]
    private var cancellables: Set<AnyCancellable> = []
    private let tableView: UITableView = UITableView()
    private let addMateButton = AddMateButton(title: "친구를 만들어봐요")
    private var mpcManager: MPCManager?
    private var niManager: NIManager?
    private var count: Int = 0
    var dogProfile: DogProfileDTO?

    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        setupMPCManager()
        super.viewDidLoad()
    }

    override func configureAttributes() {
        navigationItem.title = Context.title
        setTableView()
    }

    override func configureHierachy() {
        view.addSubview(tableView)
        view.addSubview(addMateButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addMateButton.translatesAutoresizingMaskIntoConstraints = false
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
            ),
            addMateButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            addMateButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func bind() {
        presenter?.output.mates
            .receive(on: RunLoop.main)
            .sink { [weak self] mates in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        presenter?.output.profileImageData
            .receive(on: RunLoop.main)
            .sink { [weak self] (index, imageData) in
                self?.imageDataSource[index] = imageData
                let indexPath = IndexPath(item: index, section: 0)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
            .store(in: &cancellables)
        addMateButton.publisher(event: .touchUpInside)
            .throttle(for: .seconds(EventConstant.throttleInterval),
                      scheduler: RunLoop.main,
                      latest: false)
            .sink { [weak self] _ in
                self?.mpcManager?.isAvailableToBeConnected = true
                self?.count = 1
                self?.addMateButton.buttonState = .connecting
            }
            .store(in: &cancellables)

        mpcManager?.$paired
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaired in
                if 1...3 ~= self?.count ?? 0 {
                    self?.presenter?.changeIsPaired(with: isPaired)
                } else {
                    self?.addMateButton.buttonState = .normal
                }
                self?.count += 1
            }
            .store(in: &cancellables)

        mpcManager?.receivedDataPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profile in
                SNMLogger.info("HomeViewController received data: \(profile)")
                self?.dogProfile = profile
                self?.addMateButton.buttonState = .success
            }
            .store(in: &cancellables)

        niManager?.isViewTransitioning
            .receive(on: RunLoop.main)
            .sink { [weak self] bool in
                self?.addMateButton.buttonState = .normal
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
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifier.mateCellID)
        tableView.separatorStyle = .none
    }

    private func setupMPCManager() {
        mpcManager = MPCManager(yourName: String(UUID().uuidString.suffix(8)))
        niManager = NIManager(mpcManager: mpcManager!)
    }
}

// MARK: - MateListViewController+UITableViewDelegate & UITableViewDataSource

extension MateListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.output.mates.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Identifier.mateCellID,
            for: indexPath
        )
        var content = cell.defaultContentConfiguration()
        content.image = .app
        if let imageData = imageDataSource[indexPath.row] {
            var profileImage = UIImage(data: imageData)
            profileImage = profileImage?.clipToSquareWithBackgroundColor(
                with: ItemSize.profileImageSize.width)
            content.image = profileImage
        } else {
            presenter?.didTableViewCellLoad(
                index: indexPath.row,
                imageName: presenter?.output.mates.value[indexPath.row].profileImageURLString
            )
        }
        content.imageProperties.maximumSize = ItemSize.profileImageSize
        content.imageProperties.cornerRadius = ItemSize.profileImageCornerRadius
        content.text = presenter?.output.mates.value[indexPath.row].name
        cell.contentConfiguration = content
        if let mate = presenter?.output.mates.value[indexPath.row] {
            cell.accessoryView = createAccessoryButton(mate: mate)
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ItemSize.cellHeight
    }

    private func createAccessoryButton(mate: Mate) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(origin: .zero, size: ItemSize.accessoryButtonSize)
        button.backgroundColor = SNMColor.mainBrown
        button.setTitle(Context.accessoryButtonLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true

        button.publisher(event: .touchUpInside)
            .debounce(for: .seconds(EventConstant.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.presenter?.didTabAccessoryButton(mate: mate)
            }
            .store(in: &cancellables)
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

// MARK: - UIViewControllerTransitioningDelegate

extension MateListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        CardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
