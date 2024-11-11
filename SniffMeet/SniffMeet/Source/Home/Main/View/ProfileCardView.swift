//
//  ProfileCardView.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/10/24.
//

import UIKit

final class ProfileCardView: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .systemBackground
        return label
    }()
    private let editButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = UIColor(
            red: 236 / 255,
            green: 236 / 255,
            blue: 236 / 255,
            alpha: 0.87
        )
        button.layer.cornerRadius = 22
        return button
    }()
    private let keywordStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private let profileInfoStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    init(name: String = "", keywords: [String] = [], profileImage: UIImage = .imagePlaceholder) {
        super.init(frame: .zero)
        configureAttributes(profileImage: profileImage, name: name, keywords: keywords)
        configureHierarchy()
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        profileInfoStackView.addArrangedSubview(nameLabel)
        profileInfoStackView.addArrangedSubview(keywordStackView)
        addSubview(profileImageView)
        addSubview(editButton)
        addSubview(profileInfoStackView)
    }
    private func configureConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        profileInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            editButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.widthAnchor.constraint(equalToConstant: 44),
            profileInfoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            profileInfoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
    }
    private func configureAttributes(profileImage: UIImage, name: String, keywords: [String]) {
        setProfileImage(profileImage: profileImage)
        setName(name: name)
        setKeywords(from: keywords)
        setShadow()
    }
    private func addKeywords(from keywords: [String]) {
        keywords.forEach { keyword in
            keywordStackView.addArrangedSubview(KeywordView(title: keyword))
        }
    }
    private func clearKeywords() {
        keywordStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    private func setShadow() {
        layer.cornerRadius = 15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    private func setNameLabelShadow() {
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOpacity = 0.25
        nameLabel.layer.shadowRadius = 3.0
        nameLabel.layer.masksToBounds = false
    }
    func setKeywords(from keywords: [String]) {
        clearKeywords()
        addKeywords(from: keywords)
    }
    func setName(name: String) {
        nameLabel.text = name
        setNameLabelShadow()
    }
    func setProfileImage(profileImage: UIImage) {
        profileImageView.image = profileImage
    }
}
