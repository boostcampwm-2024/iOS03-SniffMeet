//
//  SessionViewController.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/1/24.
//

import UIKit

final class SessionViewController: BaseViewController {
    private var logoImageView = UIImageView()
    private var logoTitleLabel = UILabel()
    private var smallTitleLabel = UILabel()
    
    private weak var appRouter: AppRouter?
    var walkNoti: WalkNoti?
    var isAccepted: Bool?
    
    init(appRouter: AppRouter?) {
        self.appRouter = appRouter
        super.init()
    }
    override func viewDidAppear(_ animated: Bool) {
        routeView()
    }

    override func configureAttributes() {
        logoImageView.image = UIImage.app
        logoImageView.contentMode = .scaleAspectFill
        
        logoTitleLabel.textColor = SNMColor.mainNavy
        logoTitleLabel.text = "SniffMeet"
        logoTitleLabel.font = SNMFont.bigLogoTitle
        
        
        smallTitleLabel.textColor = SNMColor.mainNavy
        smallTitleLabel.text = "반려견의 슬기로운 산책 생활을 위해!"
        smallTitleLabel.font = SNMFont.smallLogoTitle
    }
    override func configureHierachy() {
        [logoImageView, logoTitleLabel, smallTitleLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    override func configureConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: Context.imageViewPadding),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            logoTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoTitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                                constant: -Context.imageLogoVerticalPadding),
            
            smallTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            smallTitleLabel.topAnchor.constraint(equalTo: logoTitleLabel.bottomAnchor,
                                                 constant: Context.logoSmallTitleVerticalPadding)
        ])
    }
    private func routeView() {
        if let walkNoti {
            appRouter?.initializeViewAndPresentRequestView(walkNoti: walkNoti)
        } else if let isAccepted {
            appRouter?.initializeViewAndPresentRespondView(isAccepted: isAccepted)
        } else {
            appRouter?.displayInitialScreen()
        }
    }
}
extension SessionViewController {
    private enum Context {
        static let imageViewPadding: CGFloat = 60
        static let imageLogoVerticalPadding: CGFloat = 30
        static let logoSmallTitleVerticalPadding: CGFloat = 19
    }
}
