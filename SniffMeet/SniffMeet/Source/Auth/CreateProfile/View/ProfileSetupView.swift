//
//  ProfileSetupView.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/9/24.
//

import UIKit
import PhotosUI

final class ProfileSetupView: UIViewController {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Context.mainTitle
        label.textColor = UIColor.mainNavy
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        return label
    }()
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ImagePlaceholder")
        return imageView
    }()
    private var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.backgroundColor = UIColor.mainNavy
        button.setTitleColor(UIColor.white, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private var warningLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = Context.placeholder
        label.alpha = 0
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private var nicknameTextField: InputTextField = InputTextField(placeholder: Context.placeholder)
    private var submitButton = PrimaryButton(title: Context.submitBtnTitle)
    private var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        return PHPickerViewController(configuration: configuration)
    }()

    override func viewDidLoad() {
        setSubviewsLayout()
        view.backgroundColor = .white
        submitButton.isEnabled = false
        setDelegate()
        setButtonAction()
    }
    override func viewDidLayoutSubviews() {
        profileImageView.makeViewCircular()
        addPhotoButton.makeViewCircular()
    }
}

private extension ProfileSetupView {
    enum Context {
        static let submitBtnTitle: String = "등록 완료"
        static let placeholder: String = "닉네임을 입력해주세요."
        static let mainTitle: String = "마지막으로,\n사진과 닉네임을 등록해주세요."
        static let horizontalPadding: CGFloat = 24
        static let imageViewSize: CGFloat = 140
        static let addPhotoButtonSize: CGFloat = 44
    }
    enum TextFieldError: Error {
        case none               // 에러가 없는 경우
        case empty              // 아무것도 입력되지 않은 경우
        case exceededMaxLength  // 최대 글자 수를 초과한 경우
        case invalidFormat      // 포맷이 잘못된 경우 (예: 이메일 형식 등)
        case restrictedCharacter // 허용되지 않은 문자 포함
    }
    func setSubviewsLayout() {
        [titleLabel,
         profileImageView,
         addPhotoButton,
         warningLabel,
         nicknameTextField,
         submitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: Context.horizontalPadding),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: Context.imageViewSize),
            profileImageView.heightAnchor.constraint(equalToConstant: Context.imageViewSize),
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            addPhotoButton.widthAnchor.constraint(equalToConstant: Context.addPhotoButtonSize),
            addPhotoButton.heightAnchor.constraint(equalToConstant: Context.addPhotoButtonSize),
            addPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                     constant: 10),
            addPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            nicknameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                                   constant: 60),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                       constant: Context.horizontalPadding),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                        constant: -Context.horizontalPadding),
            warningLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor,
                                              constant: 16),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Context.horizontalPadding),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: Context.horizontalPadding),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -Context.horizontalPadding),
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        ])
    }
    func setDelegate() {
        picker.delegate = self
        nicknameTextField.delegate = self
    }
    func setButtonAction() {
        addPhotoButton.addAction(UIAction { [weak self] _ in
            guard let picker = self?.picker else { return }
            self?.present(picker, animated: true, completion: nil)
        }, for: .touchUpInside)
    }
}

extension ProfileSetupView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let selectedImage = image as? UIImage else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.image =  selectedImage
                }
            }
        }
    }
}

extension ProfileSetupView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField.text?.count ?? 0 < 1) || (textField.text?.count ?? 0 < 1) {
            submitButton.isEnabled = false
        } else {
            submitButton.isEnabled = true
        }
    }
}
