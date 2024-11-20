//
//  LocationSelectionView.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/19/24.
//
import UIKit

final class LocationSelectionView: BaseView {
    private var tapGesture = UITapGestureRecognizer()

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
    
    override func configureHierarchy() {
        [locationGuideLabel, locationLabel, chevronImageView].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addGestureRecognizer(tapGesture)
        
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            locationGuideLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationLabel.trailingAnchor.constraint(
                equalTo: chevronImageView.leadingAnchor,
                constant: -LayoutConstant.navigationItemSpacing),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        [locationGuideLabel, locationLabel, chevronImageView].forEach{
            $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    func setAddress(address: String) {
        locationLabel.text = address
    }

}
private extension LocationSelectionView {
    enum Context {
        static let locationGuideTitle: String = "장소 선택"
    }
}
