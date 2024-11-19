//
//  CardPresentationController.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/18/24.
//
import UIKit

final class CardPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        // 중앙에 카드처럼 보이게 할 크기 지정
        let width: CGFloat = containerView!.bounds.width * 0.9
        let height: CGFloat = containerView!.bounds.height * 0.8
        let xValue = (containerView!.bounds.width - width) / 2
        let yValue = (containerView!.bounds.height - height) / 2
        return CGRect(x: xValue, y: yValue, width: width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        if let containerView = containerView {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            blurEffectView.frame = containerView.bounds
            containerView.addSubview(blurEffectView)
            blurEffectView.alpha = 0
            
            // 애니메이션을 통해 흐림 효과가 나타나도록 설정
            if let coordinator = presentingViewController.transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    blurEffectView.alpha = 0.5
                })
            }
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        // dismiss 할 때 흐림 효과가 사라지도록 애니메이션 설정
        if let containerView = containerView {
            if let blurEffectView = containerView.subviews.first(where: { $0 is UIVisualEffectView }) {
                if let coordinator = presentingViewController.transitionCoordinator {
                    coordinator.animate(alongsideTransition: { context in
                        blurEffectView.alpha = 0
                    })
                }
            }
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let presentedView {
            presentedView.layer.cornerRadius = 20
            presentedView.clipsToBounds = true
            
            presentedView.layer.shadowColor = SNMColor.black.cgColor
            presentedView.layer.shadowOpacity = 0.25
            presentedView.layer.shadowOffset = CGSize(width: 0, height: 4)
            presentedView.layer.shadowRadius = 4
        }
    }
}
