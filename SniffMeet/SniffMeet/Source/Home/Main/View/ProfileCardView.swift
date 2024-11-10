//
//  ProfileCardView.swift
//  SniffMeet
//
//  Created by Kelly Chui on 11/10/24.
//

import UIKit

final class ProfileCardView: UIView {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .systemBackground
        return label
    }()
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 22
        return button
    }()
    lazy var keywordStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    lazy var profileInfoStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [nameLabel, keywordStack])
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    init(name: String = "dog_name", keywords: [String] = ["keyword1", "keyword2"], profileImage: UIImage = .imagePlaceholder) {
        super.init(frame: .zero)
        setProfileImage(profileImage: profileImage)
        setName(name: name)
        setKeywords(keywords: keywords)
        setupLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setKeywordViews(from keywords: [String]) {
        clearKeywordViews()
        addKeywordViews(from: keywords)
    }
    private func addKeywordViews(from keywords: [String]) {
        keywords.forEach { keyword in
            keywordStack.addArrangedSubview(KeywordView(title: keyword))
        }
    }
    private func clearKeywordViews() {
        keywordStack.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    private func setupLayouts() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        profileInfoStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImageView)
        addSubview(editButton)
        addSubview(profileInfoStack)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            editButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            profileInfoStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            profileInfoStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
    }
    func setName(name: String) {
        nameLabel.text = name
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOpacity = 0.25
        nameLabel.layer.shadowRadius = 3.0
        nameLabel.layer.masksToBounds = false
    }
    func setKeywords(keywords: [String]) {
        setKeywordViews(from: keywords)
    }
    func setProfileImage(profileImage: UIImage) {
        profileImageView.image = profileImage
    }
}
