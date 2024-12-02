//
//  PresentAnimator.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/27/24.
//
import UIKit


final class FromTop2BottomPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        toView.transform = CGAffineTransform(translationX: 0, y: -transitionContext.containerView.bounds.height)
        
        transitionContext.containerView.addSubview(toView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.transform = .identity
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
