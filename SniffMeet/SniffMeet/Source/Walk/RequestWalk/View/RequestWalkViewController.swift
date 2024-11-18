//
//  RequestWalkViewController.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//

import UIKit

final class RequestWalkViewController: BaseViewController {
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
    
    private var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.imagePlaceholder
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "진돌이"
        label.font = SNMFont.title3
        label.textColor = SNMColor.mainWhite
        return label
    }()
    
    private var locationGuideLabel: UILabel = {
        let label = UILabel()
        label.text = Context.locationGuideTitle
        label.font = SNMFont.subheadline
        label.textColor = SNMColor.mainNavy
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.font = SNMFont.subheadline
        label.textColor = SNMColor.subGray2
        label.text = "잠원 한강 공원"
        return label
    }()
    
    private var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = SNMColor.subGray2
        return imageView
    }()
    private var locationView: UIView!
    private var messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = Context.requestGuideTitle
        textView.font = SNMFont.subheadline
        textView.textColor = SNMColor.black
        textView.backgroundColor = SNMColor.subGray1
        textView.layer.cornerRadius = 10
        return textView
    }()
    private var submitButton = PrimaryButton(title: Context.mainTitle)
    
    override func configureAttributes() {
        setButtonActions()
    }
    override func configureHierachy() {
        locationView = UIView()
        [locationGuideLabel, locationLabel, chevronImageView].forEach{
            locationView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [titleLabel,
         dismissButton,
         mainImageView,
         nameLabel,
         locationView,
         messageTextView,
         submitButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: LayoutConstant.xlargeVerticalPadding),
            
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor,
                                               constant: LayoutConstant.regularVerticalPadding),
            dismissButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding),
            dismissButton.heightAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            dismissButton.widthAnchor.constraint(equalToConstant: LayoutConstant.iconSize),
            
            mainImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            mainImageView.widthAnchor.constraint(equalTo: mainImageView.heightAnchor),
            
            locationView.topAnchor.constraint(
                equalTo: mainImageView.bottomAnchor,
                constant: LayoutConstant.mediumVerticalPadding),
            locationView.bottomAnchor.constraint(
                equalTo: messageTextView.topAnchor,
                constant: -LayoutConstant.regularVerticalPadding),
            
            locationGuideLabel.leadingAnchor.constraint(equalTo: locationView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor,
                                                constant: -LayoutConstant.navigationItemSpacing),
            chevronImageView.trailingAnchor.constraint(equalTo: locationView.trailingAnchor),
            
            messageTextView.bottomAnchor.constraint(
                equalTo: submitButton.topAnchor,
                constant: -LayoutConstant.xlargeVerticalPadding),
            
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                 constant: -LayoutConstant.xlargeVerticalPadding),
        ])
        
        [locationGuideLabel, locationLabel,chevronImageView].forEach{
            $0.topAnchor.constraint(
                equalTo: mainImageView.bottomAnchor,
                constant: LayoutConstant.mediumVerticalPadding).isActive = true
            $0.bottomAnchor.constraint(
                equalTo: messageTextView.topAnchor,
                constant: -LayoutConstant.regularVerticalPadding).isActive = true
        }
        
        [locationView, messageTextView, submitButton].forEach {
            $0.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: LayoutConstant.smallHorizontalPadding).isActive = true
            $0.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -LayoutConstant.smallHorizontalPadding).isActive = true
        }
    }
    override func bind() {
    }
}

private extension RequestWalkViewController {
    enum Context {
        static let mainTitle: String = "산책 요청 보내기"
        static let locationGuideTitle: String = "장소 선택"
        static let requestGuideTitle: String = "간단한 요청 메세지를 작성해주세요."
    }
    
    func setButtonActions() {
        dismissButton.addAction(UIAction(handler: {[weak self] _ in
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
    }
}
