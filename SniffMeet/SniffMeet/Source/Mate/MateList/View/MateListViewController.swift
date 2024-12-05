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
    var imageDataSource: [UUID: Data] = [:]
    private var cancellables: Set<AnyCancellable> = []
    private let tableView: UITableView = UITableView()
    private let addMateButton = AddMateButton(title: "새 메이트를 연결하세요")
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showSentAlert),
            name: .init(rawValue: "requestWalk"),
            object: nil
        )
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
                self?.addMateButton.buttonState = .normal
            }
            .store(in: &cancellables)
        presenter?.output.profileImageData
            .receive(on: RunLoop.main)
            .sink { [weak self] (mateID, imageData) in
                self?.imageDataSource[mateID] = imageData
                guard let index = self?.presenter?.output.mates.value.firstIndex(where: {
                    $0.userID == mateID
                }) else { return }
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
                    if !isPaired {
                        self?.addMateButton.buttonState = .failure
                        self?.presenter?.showAlertDisconnected()
                    }
                    self?.addMateButton.buttonState = .connecting
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

        niManager?.$niPaired
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaired in
                if isPaired {
                    self?.presenter?.showAlertConnected()
                    self?.addMateButton.buttonState = .success
                } else {
                    self?.addMateButton.buttonState = .failure
                }
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
    }
    
    @objc private func showSentAlert() {
        showSNMTextAndImageToast(
            image: UIImage(systemName: "paperplane.fill"),
            text: "전송 완료!",
            animationType: .slideDown
        )
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
        guard let mate = presenter?.output.mates.value[indexPath.row] else { return cell }
        var content = cell.defaultContentConfiguration()
        content.image = .app
        if let imageData = imageDataSource[mate.userID] {
            var profileImage = UIImage(data: imageData)
            profileImage = profileImage?.clipToSquareWithBackgroundColor(
                with: ItemSize.profileImageSize.width)
            content.image = profileImage
        } else {
            presenter?.didTableViewCellLoad(
                mateID: mate.userID,
                imageName: mate.profileImageURLString
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
