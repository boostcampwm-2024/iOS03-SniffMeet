//
//  ProfileView.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/19/24.
//
import UIKit

final class ProfileView: BaseView {
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    private var firstKeywordView: KeywordView = {
        let view = KeywordView(title: "")
        return view
    }()
    private var secondKeywordView: KeywordView = {
        let view = KeywordView(title: "")
        return view
    }()
    private var nameLabel: PaddingLabel = {
        let label = PaddingLabel(paddingType: .horizontal)
        label.font = SNMFont.title3
        label.textColor = SNMColor.mainWhite
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        return label
    }()
    
    
    override func configureHierarchy() {
        [imageView, firstKeywordView, secondKeywordView, nameLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            firstKeywordView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: LayoutConstant.smallHorizontalPadding),
            firstKeywordView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            secondKeywordView.centerYAnchor.constraint(equalTo: firstKeywordView.centerYAnchor),
            secondKeywordView.leadingAnchor.constraint(
                equalTo: firstKeywordView.trailingAnchor,
                constant: LayoutConstant.tagHorizontalSpacing),
            
            nameLabel.bottomAnchor.constraint(equalTo: firstKeywordView.topAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstant.smallHorizontalPadding)
        ])
    }
    
    override func configureAttributes() {
        styleLabel(nameLabel)
    }
    func styleLabel(_ label: UILabel) {
        label.backgroundColor = SNMColor.subGray3.withAlphaComponent(0.6)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
    }
    
    func configure(dog: UserInfo) {
        nameLabel.text = dog.name
        
        guard let firstKeyword = dog.keywords.first else { return }
        firstKeywordView.text = firstKeyword.rawValue
        
        guard dog.keywords.count > 1 else { return }
        secondKeywordView.text = dog.keywords[1].rawValue
    }
    
    func configureImage(with image: UIImage?) {
        imageView.image = image ?? UIImage.imagePlaceholder
    }
}
