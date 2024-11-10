//
//  ProfileInputView.swift
//  SniffMeet
//
//  Created by 배현진 on 11/10/24.
//

import UIKit

class ProfileInputView: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "반가워요!\n당신의 반려견을 소개해주세요."
        label.textColor = UIColor.mainNavy
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: .init(24), weight: .heavy)
        return label
    }()
    private var nameTextField: InputTextField = InputTextField(placeholder: "반려견 이름을 입력해주세요.")
    private var ageTextField: InputTextField = InputTextField(placeholder: "반려견 나이를 입력해주세요.")
    private var sizeSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "반려견의 크기를 선택해주세요."
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["소형", "중형", "대형"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    private var keywordSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "반려견에 해당되는 키워드를 선택해주세요."
        label.font = .systemFont(ofSize: .init(16), weight: .regular)
        return label
    }()
    private var activeKeywordButton: UIButton = KeywordButton(title: "활발한")
    private var smartKeywordButton: UIButton = KeywordButton(title: "똑똑한")
    private var friendlyKeywordButton: UIButton = KeywordButton(title: "친화력 좋은")
    private var shyKeywordButton: UIButton = KeywordButton(title: "소심한")
    private var independentKeywordButton: UIButton = KeywordButton(title: "독립적인")
    private var nextButton: UIButton = PrimaryButton(title: "다음으로")

    override func viewDidLoad() {
        super.viewDidLoad()

        setSubveiws()

        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        updateNextButtonState()
        hideKeyboardWhenTappedAround()
    }

    private func setSubveiws() {
        view.backgroundColor = .white

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        sizeSelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        keywordSelectionLabel.translatesAutoresizingMaskIntoConstraints = false
        activeKeywordButton.translatesAutoresizingMaskIntoConstraints = false
        smartKeywordButton.translatesAutoresizingMaskIntoConstraints = false
        friendlyKeywordButton.translatesAutoresizingMaskIntoConstraints = false
        shyKeywordButton.translatesAutoresizingMaskIntoConstraints = false
        independentKeywordButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(ageTextField)
        view.addSubview(sizeSelectionLabel)
        view.addSubview(segmentedControl)
        view.addSubview(keywordSelectionLabel)
        view.addSubview(activeKeywordButton)
        view.addSubview(smartKeywordButton)
        view.addSubview(friendlyKeywordButton)
        view.addSubview(shyKeywordButton)
        view.addSubview(independentKeywordButton)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            sizeSelectionLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor,
                                                    constant: 60),
            sizeSelectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            segmentedControl.topAnchor.constraint(equalTo: sizeSelectionLabel.bottomAnchor,
                                                  constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            keywordSelectionLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                                       constant: 30),
            keywordSelectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                           constant: 24),

            activeKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                     constant: 16),
            activeKeywordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            smartKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                    constant: 16),
            smartKeywordButton.leadingAnchor.constraint(equalTo: activeKeywordButton.trailingAnchor,
                                                        constant: 8),

            friendlyKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                       constant: 16),
            friendlyKeywordButton.leadingAnchor.constraint(equalTo: smartKeywordButton.trailingAnchor,
                                                           constant: 8),

            shyKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                  constant: 16),
            shyKeywordButton.leadingAnchor.constraint(equalTo: friendlyKeywordButton.trailingAnchor,
                                                      constant: 8),

            independentKeywordButton.topAnchor.constraint(equalTo: keywordSelectionLabel.bottomAnchor,
                                                          constant: 16),
            independentKeywordButton.leadingAnchor.constraint(equalTo: shyKeywordButton.trailingAnchor,
                                                              constant: 8),

            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}

extension ProfileInputView {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(ProfileInputView.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
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
