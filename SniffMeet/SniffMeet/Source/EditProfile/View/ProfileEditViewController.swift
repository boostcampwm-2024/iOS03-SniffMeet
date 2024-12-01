//
//  ProfileEditView.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/28/24.
//

import Combine
import UIKit

protocol ProfileEditViewable: AnyObject {
    // var presenter: (any ProfileEditPresentable)?
}

final class ProfileEditViewController: BaseViewController, ProfileEditViewable {
    var presenter: ProfileEditPresentable?
    private var cancellables = Set<AnyCancellable>()
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
        segmentedControl.selectedSegmentIndex = 0
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
    private var keywordStackView = UIStackView()
    private var keywordButtons: [KeywordButton] {
        [energeticKeywordButton,
         smartKeywordButton,
         friendlyKeywordButton,
         shyKeywordButton,
         independentKeywordButton]
    }
    private var nextButton = PrimaryButton(title: Context.nextBtnTitle)

    override func viewDidLoad() {
        setupBinding()
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.makeViewCircular()
        addPhotoButton.makeViewCircular()
    }

    override func configureHierachy() {
        [profileImageView,
         addPhotoButton,
         nameTextLabel,
         nameTextField,
         ageTextLabel,
         ageTextField,
         sizeSelectionLabel,
         sizeSegmentedControl,
         keywordSelectionLabel,
         keywordStackView,
         nextButton].forEach { subview in
            view.addSubview(subview)
        }

        keywordButtons.forEach { keywordButton in
            keywordStackView.addArrangedSubview(keywordButton)
        }
    }

    override func configureConstraints() {
        disableAutoresizingMaskForSubviews()
        configureNextButtonConstraints()
        configureProfileImageViewConstraints()

        NSLayoutConstraint.activate([
            nameTextLabel.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor,
                constant: Context.largeVerticalPadding
            ),
            nameTextLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            nameTextField.topAnchor.constraint(
                equalTo: nameTextLabel.bottomAnchor,
                constant: Context.basicVerticalPadding
            ),
            nameTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            nameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Context.horizontalPadding
            ),
            ageTextLabel.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: Context.basicVerticalPadding
            ),
            ageTextLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            ageTextField.topAnchor.constraint(
                equalTo: ageTextLabel.bottomAnchor,
                constant: Context.basicVerticalPadding
            ),
            ageTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            ageTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Context.horizontalPadding
            ),
            sizeSelectionLabel.topAnchor.constraint(
                equalTo: ageTextField.bottomAnchor,
                constant: Context.basicVerticalPadding
            ),
            sizeSelectionLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            sizeSegmentedControl.topAnchor.constraint(
                equalTo: sizeSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding
            ),
            sizeSegmentedControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            sizeSegmentedControl.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Context.horizontalPadding
            ),
            keywordSelectionLabel.topAnchor.constraint(
                equalTo: sizeSegmentedControl.bottomAnchor,
                constant: Context.basicVerticalPadding
            ),
            keywordSelectionLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            keywordStackView.topAnchor.constraint(
                equalTo: keywordSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding
            ),
            keywordStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding
            ),
            keywordStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Context.horizontalPadding
            )
        ])
        configureButtonConstraints()
    }

    override func configureAttributes() {

    }

    override func bind() {}

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
                self?.nextButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
    }
    private func disableAutoresizingMaskForSubviews() {
        [nameTextLabel,
         nameTextField,
         ageTextLabel,
         ageTextField,
         sizeSelectionLabel,
         sizeSegmentedControl,
         keywordSelectionLabel,
         keywordStackView,
         nextButton,
         profileImageView,
         addPhotoButton].forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        keywordButtons.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureNextButtonConstraints() {
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -32
            ),
            nextButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            nextButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            )
        ])
    }

    private func configureProfileImageViewConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 60
            ),
            profileImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            profileImageView.widthAnchor.constraint(
                equalToConstant: 100
            ),
            profileImageView.heightAnchor.constraint(
                equalToConstant: 100
            ),
            addPhotoButton.widthAnchor.constraint(
                equalToConstant: 32
            ),
            addPhotoButton.heightAnchor.constraint(
                equalToConstant: 32
            ),
            addPhotoButton.trailingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor
            ),
            addPhotoButton.bottomAnchor.constraint(
                equalTo: profileImageView.bottomAnchor
            )
        ])

    }
    
    func configureButtonConstraints() {
        keywordStackView.spacing = Context.smallVerticalPadding
        keywordStackView.axis = .horizontal
        keywordStackView.distribution = .fillProportionally

        NSLayoutConstraint.activate([
            keywordStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Context.horizontalPadding),
            keywordStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Context.horizontalPadding),
            keywordStackView.topAnchor.constraint(
                equalTo: keywordSelectionLabel.bottomAnchor,
                constant: Context.basicVerticalPadding),
            keywordStackView.heightAnchor.constraint(equalToConstant: 30)

        ])
    }

    func setButtonAction() {
        // next button
        // binding 하여 기존 정보를 가져와야 합니다.

        // keyword button
        // 최대 2개까지만 선택, 2개 넘어가면 얼럿이든지 뭐든지 띄우기
    }
}

// MARK: - ProfileEditViewControlle+UITextFieldDelegate

extension ProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 2
    }
}

extension ProfileEditViewController {
    enum Context {
        static let nextBtnTitle: String = "다음으로"
        static let namePlaceholder: String = "반려견 이름을 입력해주세요."
        static let agePlaceholder: String = "반려견 나이를 입력해주세요."
        static let sexLabel: String = "반려견의 성별을 선택해주세요."
        static let sizeLabel: String = "반려견의 크기를 선택해주세요."
        static let sizeArr: [String] = [
            Size.small.rawValue,
            Size.medium.rawValue,
            Size.big.rawValue
        ]
        static let keywordLabel: String = "반려견에 해당되는 키워드를 선택해주세요.(최대 2개)"
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
