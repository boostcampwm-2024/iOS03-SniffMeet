//
//  RequestWalkViewController.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import Combine
import UIKit

protocol RequestWalkViewable: AnyObject {
    var presenter: RequestWalkPresentable? { get set }
}

final class RequestWalkViewController: BaseViewController, RequestWalkViewable {
    var presenter: RequestWalkPresentable?
    private var cancellables: Set<AnyCancellable> = []
    private var address: Address?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var textViewEdited: Bool = false
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
        return label
    }()

    private var profileView: ProfileView = {
        let view = ProfileView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    private var locationView = LocationSelectionView()
    private var messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = Context.messagePlaceholder
        textView.font = SNMFont.subheadline
        textView.backgroundColor = SNMColor.subGray1
        textView.layer.cornerRadius = 10
        let padding = LayoutConstant.edgePadding
        textView.textContainerInset = UIEdgeInsets(top: padding,
                                                   left: padding,
                                                   bottom: padding,
                                                   right: padding)
        textView.textColor = .lightGray
        return textView
    }()
    private var submitButton = PrimaryButton(title: Context.mainTitle)

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self
        view.backgroundColor = .systemBackground
        presenter?.viewDidLoad()
        scrollView.delegate = self

    }
    override func configureAttributes() {
        hideKeyboardWhenTappedAround()
        updateSubmitButtonState()
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
         messageTextView,
         submitButton].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    override func configureConstraints() {
        scrollView.keyboardLayoutGuide.followsUndockedKeyboard = true
        setScrollViewConstraint()
        setInsideScrollViewConstraints()
    }
    
    func setScrollViewConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo:
                                                    scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(
                equalToConstant: max(650, UIApplication.screenHeight * 0.8))
        ])
    }
    func setInsideScrollViewConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: LayoutConstant.xlargeVerticalPadding),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            dismissButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: LayoutConstant.regularVerticalPadding),
            dismissButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding),
            dismissButton.heightAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            dismissButton.widthAnchor.constraint(equalToConstant: LayoutConstant.iconSize),

            profileView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            profileView.widthAnchor.constraint(equalTo: profileView.heightAnchor),

            locationView.topAnchor.constraint(
                equalTo: profileView.bottomAnchor,
                constant: LayoutConstant.mediumVerticalPadding),
            locationView.bottomAnchor.constraint(
                equalTo: messageTextView.topAnchor,
                constant: -LayoutConstant.regularVerticalPadding),
            locationView.heightAnchor.constraint(equalToConstant: 25),
            messageTextView.heightAnchor.constraint(equalToConstant: 140),

            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -LayoutConstant.xlargeVerticalPadding),
            submitButton.heightAnchor.constraint(equalToConstant: 51)
        ])
        
        [locationView, messageTextView, submitButton].forEach {
            $0.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: LayoutConstant.smallHorizontalPadding).isActive = true
            $0.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding).isActive = true
        }
    }
    override func bind() {
        presenter?.output.mateInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] mate in
                guard let mate else {
                    SNMLogger.error("Mate 바인딩 실패")
                    return
                }
                self?.profileView.configure(
                    name: mate.name,
                    keywords: mate.keywords.map { $0.rawValue }
                )
            }
            .store(in: &cancellables)
        presenter?.output.selectedLocation
            .receive(on: RunLoop.main)
            .sink { [weak self] address in
                self?.address = address
                self?.locationView.setAddress(
                    address: address?.location ?? Context.locationGuideTitle
                )
                self?.updateSubmitButtonState()
            }
            .store(in: &cancellables)
        presenter?.output.profileImageData
            .receive(on: RunLoop.main)
            .sink { [weak self] imageData in
                if let imageData {
                    let profileImage = UIImage(data: imageData)
                    self?.profileView.configureImage(with: profileImage)
                } else {
                    self?.profileView.configureImage(with: nil)
                }
            }
            .store(in: &cancellables)
        locationView.tapPublisher
            .debounce(for: .seconds(EventConstant.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.presenter?.didTapLocationButton()
            }
            .store(in: &cancellables)
        
        dismissButton.publisher(event: .touchUpInside)
            .debounce(for: .seconds(EventConstant.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.presenter?.closeTheView()
            }
            .store(in: &cancellables)
    
        submitButton.publisher(event: .touchUpInside)
            .debounce(for: .seconds(EventConstant.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let message = self?.messageTextView.text,
                      let latitude = self?.address?.latitude,
                      let longtitude = self?.address?.longtitude,
                      let location = self?.address?.location else { return }
                self?.presenter?.requestWalk(message: message,
                                             latitude: latitude,
                                             longtitude: longtitude,
                                             location: location)
            }
            .store(in: &cancellables)
    }
    func updateSubmitButtonState() {
        if textViewEdited == false {
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = (messageTextView.text.isEmpty == false) && (address != nil)
        }
        
    }
}

private extension RequestWalkViewController {
    enum Context {
        static let mainTitle: String = "산책 요청 보내기"
        static let locationGuideTitle: String = "장소 선택"
        static let messagePlaceholder: String = "간단한 요청 메세지를 작성해주세요."
        static let characterCountLimit: Int = 100
    }
}

extension RequestWalkViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        Task {[weak self] in
            try? await Task.sleep(nanoseconds: 10_000_000) // 50ms (0.05초)
            self?.scrollView.scrollRectToVisible(textView.frame, animated: true)
        }

        if textView.text == Context.messagePlaceholder {
            textView.text = nil
            textView.textColor = .black
            textViewEdited = true
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Context.messagePlaceholder
            textView.textColor = .lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        updateSubmitButtonState()
    }
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text,
              let newRange = Range(range, in: oldString) else {
            return true
        }
        let newString = oldString.replacingCharacters(
            in: newRange,
            with: inputString
        ).trimmingCharacters(in: .whitespacesAndNewlines)
        let characterCount = newString.count
        guard characterCount <= Context.characterCountLimit else { return false }
        return true
    }
}
