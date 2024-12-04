//
//  ProfileEditView.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/28/24.
//

import Combine
import PhotosUI
import UIKit

protocol ProfileEditViewable: AnyObject {
    var presenter: (any ProfileEditPresentable)? { get set }
}

final class ProfileEditViewController: BaseViewController, ProfileEditViewable {
    var presenter: (any ProfileEditPresentable)?
    private var cancellables = Set<AnyCancellable>()
    private let scrollView = UIScrollView()
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ImagePlaceholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.backgroundColor = SNMColor.mainNavy
        button.setTitleColor(SNMColor.white, for: .normal)
        button.tintColor = SNMColor.white
        return button
    }()
    private var profileImageContainerView = UIView()
    private var nameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var nameTextField: InputTextField = InputTextField(placeholder: "반려견 이름을 입력해주세요")
    private var ageTextLabel: UILabel = {
        let label = UILabel()
        label.text = "나이"
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var ageTextField: InputTextField = InputTextField(placeholder: "반려견 나이를 입력해주세요")
    private var sizeSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sizeLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var sizeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Context.sizeArr)
        segmentedControl.selectedSegmentIndex = -1
        return segmentedControl
    }()
    private var keywordSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.keywordLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var energeticKeywordButton = KeywordButton(title: Context.energeticKeywordLabel)
    private var smartKeywordButton = KeywordButton(title: Context.smartKeywordLabel)
    private var friendlyKeywordButton = KeywordButton(title: Context.friendlyKeywordLabel)
    private var shyKeywordButton = KeywordButton(title: Context.shyKeywordLabel)
    private var independentKeywordButton = KeywordButton(title: Context.independentKeywordLabel)
    private var contentsStackView = UIStackView()
    private var keywordStackView = UIStackView()
    private var keywordButtons: [KeywordButton] {
        [energeticKeywordButton,
         smartKeywordButton,
         friendlyKeywordButton,
         shyKeywordButton,
         independentKeywordButton]
    }
    private var completeEditButton = PrimaryButton(title: Context.completeEditButtonTitle)
    private var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        return PHPickerViewController(configuration: configuration)
    }()

    private var selectedKeywordButtons: [KeywordButton] = []

    override func viewDidLoad() {
        setupBinding()
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.makeViewCircular()
        addPhotoButton.makeViewCircular()
    }

    override func configureHierachy() {
        [profileImageView, addPhotoButton].forEach { subview in
            profileImageContainerView.addSubview(subview)
        }
        keywordButtons.forEach { keywordButton in
            keywordStackView.addArrangedSubview(keywordButton)
        }
        [profileImageContainerView,
         nameTextLabel,
         nameTextField,
         ageTextLabel,
         ageTextField,
         sizeSelectionLabel,
         sizeSegmentedControl,
         keywordSelectionLabel,
         keywordStackView,
         completeEditButton].forEach { subview in
            contentsStackView.addArrangedSubview(subview)
        }
        view.addSubview(scrollView)
        scrollView.addSubview(contentsStackView)
    }

    override func configureConstraints() {
        disableAutoresizingMaskForSubviews()
        configureScrollViewConstraints()
        configureContentsStackViewConstraints()
        configureProfileImageContainerViewConstraints()
        configureKeywordStackViewConstraints()
    }

    override func configureAttributes() {
        hideKeyboardWhenTappedAround()
        configureNavigationControllerAttributes()
        configureDelegateForSubviews()
        configureContentsStackViewAttributes()
        configureKeywordStackViewAttributes()
        ageTextField.keyboardType = .numberPad
    }

    private func configureDelegateForSubviews() {
        picker.delegate = self
        nameTextField.delegate = self
        ageTextField.delegate = self
    }

    private func configureNavigationControllerAttributes() {
        navigationController?.navigationBar.configureBackButton()
        navigationItem.title = Context.title
        navigationItem.largeTitleDisplayMode = .never
    }

    private func configureContentsStackViewAttributes() {
        contentsStackView.axis = .vertical
        contentsStackView.alignment = .fill
        contentsStackView.distribution = .fill
    }

    private func configureKeywordStackViewAttributes() {
        keywordStackView.axis = .horizontal
        keywordStackView.alignment = .fill
        keywordStackView.distribution = .fillProportionally
    }

    override func bind() {
        bindKeywordButtonAction()
        bindAddPhotoButtonAction()
        bindCompleteEditButtonAction()

        presenter?.output.userInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] userInfo in
                SNMLogger.info("Edit userInfo: \(userInfo)")
                self?.nameTextField.text = userInfo.name
                self?.ageTextField.text = String(userInfo.age)
                switch userInfo.size {
                case .small:
                    self?.sizeSegmentedControl.selectedSegmentIndex = 0
                case .medium:
                    self?.sizeSegmentedControl.selectedSegmentIndex = 1
                case .big:
                    self?.sizeSegmentedControl.selectedSegmentIndex = 2
                }
                self?.sizeSegmentedControl.setNeedsLayout()
                self?.selectedKeywordButtons.removeAll()
                for button in self?.keywordButtons ?? [] {
                    if let title = button.titleLabel?.text,
                       userInfo.keywords.contains(Keyword(rawValue: title) ?? .energetic) {
                        button.isSelected = true
                        self?.selectedKeywordButtons.append(button)
                    } else {
                        button.isSelected = false
                    }
                }

                if let profileImageData = userInfo.profileImage,
                   let uiImage = UIImage(data: profileImageData) {
                    self?.profileImageView.image = uiImage
                }
            }
            .store(in: &cancellables)
    }

    private func bindKeywordButtonAction() {
        keywordButtons.forEach { keywordButton in
            keywordButton.publisher(event: .touchUpInside)
                .sink { [weak self] in
                    if keywordButton.isSelected {
                        if self?.selectedKeywordButtons.count ?? 0 < 2 {
                            self?.selectedKeywordButtons.append(keywordButton)
                        } else {
                            keywordButton.isSelected = false
                        }
                    } else {
                        self?.selectedKeywordButtons.removeAll { $0 == keywordButton }
                    }
                }
                .store(in: &cancellables)
        }
    }

    private func bindAddPhotoButtonAction() {
        addPhotoButton.publisher(event: .touchUpInside)
            .sink { [weak self] in
                guard let picker = self?.picker else { return }
                self?.present(picker, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }

    private func bindCompleteEditButtonAction() {
        completeEditButton.publisher(event: .touchUpInside)
            .sink { [weak self] in
                self?.presenter?.didTapCompleteButton(
                    name: self?.nameTextField.text,
                    age: self?.ageTextField.text,
                    keywords: self?.selectedKeywordButtons
                        .compactMap { $0.titleLabel?.text },
                    size: self?.sizeSegmentedControl.selectedSegmentIndex,
                    profileImage: self?.profileImageView.image
                )
            }
            .store(in: &cancellables)
    }

    private func setupBinding() {
        let namePublisher = nameTextField
            .publisher(for: \.text)
            .map { $0 ?? "" }
            .eraseToAnyPublisher()
        let agePublisher = ageTextField
            .publisher(for: \.text)
            .map { $0 ?? "0" }
            .eraseToAnyPublisher()
        Publishers.CombineLatest(namePublisher, agePublisher)
            .map { !$0.isEmpty && Int($1) != nil }
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.completeEditButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
    }
}

// MARK: - ProfileEditViewControlle+UITextFieldDelegate

extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        if textField == nameTextField, let text = textField.text {
            let newLength = text.count + string.count - range.length
            return newLength <= 15
        }
        if textField == ageTextField, let text = textField.text {
            let allowedCharacters = CharacterSet.decimalDigits
            let inputCharacters = CharacterSet(charactersIn: string)
            let filteredInputCharacters = allowedCharacters.isSuperset(of: inputCharacters)
            let newLength = text.count + string.count - range.length
            return filteredInputCharacters && newLength <= 2
        }
        return true
    }
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = textField.convert(textField.bounds, to: scrollView)
        let offset = (scrollView.frame.height - rect.height) / 2
        let targetPoint = CGPoint(x: 0, y: rect.origin.y - offset)

        scrollView.setContentOffset(targetPoint, animated: true)
    }
}

// MARK: - ProfileEditViewController+PHPickerViewControllerDelegate

extension ProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let selectedImage = image as? UIImage else { return }
                Task { @MainActor [weak self] in
                    self?.profileImageView.image =  selectedImage
                }
            }
        }
    }
}

// MARK: - ProfileEditViewController Layout

extension ProfileEditViewController {
    private func disableAutoresizingMaskForSubviews() {
        profileImageContainerView.subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        keywordStackView.arrangedSubviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        contentsStackView.arrangedSubviews.forEach { subview in
            contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureScrollViewConstraints() {
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }

    private func configureContentsStackViewConstraints() {
        let layoutGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(
                equalTo: layoutGuide.topAnchor,
                constant: 30
            ),
            contentsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentsStackView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            contentsStackView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            contentsStackView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor)
        ])
        contentsStackView.layoutMargins = UIEdgeInsets(
            top: 60,
            left: 24,
            bottom: 30,
            right: 24
        )
        contentsStackView.isLayoutMarginsRelativeArrangement = true
        contentsStackView.spacing = Context.basicVerticalPadding
        contentsStackView.setCustomSpacing(30, after: profileImageContainerView)
        contentsStackView.setCustomSpacing(30, after: nameTextField)
        contentsStackView.setCustomSpacing(30, after: ageTextField)
        contentsStackView.setCustomSpacing(30, after: sizeSegmentedControl)
        contentsStackView.setCustomSpacing(30, after: keywordStackView)
    }

    private func configureProfileImageContainerViewConstraints() {
        NSLayoutConstraint.activate([
            profileImageContainerView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.centerXAnchor.constraint(
                equalTo: profileImageContainerView.centerXAnchor
            ),
            profileImageView.centerYAnchor.constraint(
                equalTo: profileImageContainerView.centerYAnchor
            ),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 32),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 32),
            addPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            addPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor)
        ])
    }

    private func configureKeywordStackViewConstraints() {
        keywordStackView.spacing = Context.smallVerticalPadding
    }
}

// MARK: - ProfileEditViewController Contexts

extension ProfileEditViewController {
    enum Context {
        static let title: String = "반려동물 정보 수정"
        static let completeEditButtonTitle: String = "수정하기"
        static let namePlaceholder: String = "기존 이름"
        static let agePlaceholder: String = "기존 나이"
        static let sizeLabel: String = "반려견의 크기를 선택해주세요."
        static let sizeArr: [String] = [
            Size.small.rawValue,
            Size.medium.rawValue,
            Size.big.rawValue
        ]
        static let keywordLabel: String = "반려견에 해당되는 키워드를 최대 2개 선택해주세요."
        static let energeticKeywordLabel: String = Keyword.energetic.rawValue
        static let smartKeywordLabel: String = Keyword.smart.rawValue
        static let friendlyKeywordLabel: String = Keyword.friendly.rawValue
        static let shyKeywordLabel: String = Keyword.shy.rawValue
        static let independentKeywordLabel: String = Keyword.independent.rawValue
        static let horizontalPadding: CGFloat = 24
        static let smallVerticalPadding: CGFloat = 8
        static let basicVerticalPadding: CGFloat = 16
        static let largeVerticalPadding: CGFloat = 30
    }
}
