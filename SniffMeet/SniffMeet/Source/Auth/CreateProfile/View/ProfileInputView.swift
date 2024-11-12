//
//  ProfileInputView.swift
//  SniffMeet
//
//  Created by 배현진 on 11/10/24.
//

import UIKit

final class ProfileInputView: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Context.titleLabel
        label.textColor = SNMColor.mainNavy
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: .init(24), weight: .heavy)
        return label
    }()
    private var nameTextField: InputTextField = InputTextField(placeholder: Context.namePlaceholder)
    private var ageTextField: InputTextField = InputTextField(placeholder: Context.agePlaceholder)
    private var sizeSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.sizeLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Context.smallSize, Context.mediumSize, Context.largeSize])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    private var keywordSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Context.keywordLabel
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var activeKeywordButton: UIButton = KeywordButton(title: Context.activeKeywordLabel)
    private var smartKeywordButton: UIButton = KeywordButton(title: Context.smartKeywordLabel)
    private var friendlyKeywordButton: UIButton = KeywordButton(title: Context.friendlyKeywordLabel)
    private var shyKeywordButton: UIButton = KeywordButton(title: Context.shyKeywordLabel)
    private var independentKeywordButton: UIButton = KeywordButton(title: Context.independentKeywordLabel)
    private var nextButton: UIButton = PrimaryButton(title: Context.nextBtnTitle)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SNMColor.white
        setSubveiws()
        setSubviewsLayout()
        updateNextButtonState()
        hideKeyboardWhenTappedAround()

        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                               for: .editingChanged)
    }
}

private extension ProfileInputView {
    enum Context {
        static let nextBtnTitle: String = "다음으로"
        static let titleLabel: String = "반가워요!\n당신의 반려견을 소개해주세요."
        static let namePlaceholder: String = "반려견 이름을 입력해주세요."
        static let agePlaceholder: String = "반려견 나이를 입력해주세요."
        static let sizeLabel: String = "반려견의 크기를 선택해주세요."
        static let smallSize: String = "소형"
        static let mediumSize: String = "중형"
        static let largeSize: String = "대형"
        static let keywordLabel: String = "반려견에 해당되는 키워드를 선택해주세요."
        static let activeKeywordLabel: String = "활발한"
        static let smartKeywordLabel: String = "똑똑한"
        static let friendlyKeywordLabel: String = "친화력 좋은"
        static let shyKeywordLabel: String = "소심한"
        static let independentKeywordLabel: String = "독립적인"
        static let horizontalPadding: CGFloat = 24
        static let smallVerticalPadding: CGFloat = 8
        static let basicVerticalPadding: CGFloat = 16
        static let largeVerticalPadding: CGFloat = 30
    }

    func setSubveiws() {
        [titleLabel,
        nameTextField,
        ageTextField,
        sizeSelectionLabel,
        segmentedControl,
        keywordSelectionLabel,
        activeKeywordButton,
        smartKeywordButton,
        friendlyKeywordButton,
        shyKeywordButton,
        independentKeywordButton,
         nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    func setSubviewsLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: Context.basicVerticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: Context.horizontalPadding),

            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: Context.horizontalPadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -Context.horizontalPadding),

            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                              constant: Context.largeVerticalPadding),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Context.horizontalPadding),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -Context.horizontalPadding),

            sizeSelectionLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor,
                                                    constant: 60),
            sizeSelectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                        constant: Context.horizontalPadding),

            segmentedControl.topAnchor.constraint(equalTo: sizeSelectionLabel.bottomAnchor,
                                                  constant: Context.basicVerticalPadding),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant: Context.horizontalPadding),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant: -Context.horizontalPadding),

            keywordSelectionLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                                       constant: Context.largeVerticalPadding),
            keywordSelectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                           constant: Context.horizontalPadding),

            activeKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                     constant: Context.basicVerticalPadding),
            activeKeywordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: Context.horizontalPadding),

            smartKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                    constant: Context.basicVerticalPadding),
            smartKeywordButton.leadingAnchor.constraint(equalTo: activeKeywordButton.trailingAnchor,
                                                        constant: Context.smallVerticalPadding),

            friendlyKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                       constant: Context.basicVerticalPadding),
            friendlyKeywordButton.leadingAnchor.constraint(
                equalTo: smartKeywordButton.trailingAnchor, constant: Context.smallVerticalPadding),

            shyKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                  constant: Context.basicVerticalPadding),
            shyKeywordButton.leadingAnchor.constraint(
                equalTo: friendlyKeywordButton.trailingAnchor, constant: Context.smallVerticalPadding),

            independentKeywordButton.topAnchor.constraint(
                equalTo: keywordSelectionLabel.bottomAnchor, constant: Context.basicVerticalPadding),
            independentKeywordButton.leadingAnchor.constraint(
                equalTo: shyKeywordButton.trailingAnchor, constant: Context.smallVerticalPadding),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: Context.horizontalPadding),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Context.horizontalPadding)
        ])
    }
}

extension ProfileInputView: UITextFieldDelegate {
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateNextButtonState()
    }

    private func updateNextButtonState() {
        let isNameFilled = !(nameTextField.text ?? "").isEmpty
        let isAgeFilled = !(ageTextField.text ?? "").isEmpty
        nextButton.isEnabled = isNameFilled && isAgeFilled
    }
}
