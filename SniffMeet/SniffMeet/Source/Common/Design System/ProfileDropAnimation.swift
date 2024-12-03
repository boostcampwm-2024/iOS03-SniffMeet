//
//  ProfileDropAnimation.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/3/24.
//
import UIKit

final class SpringBlurAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext:
                            UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = containerView.bounds
        blurView.alpha = 0.0
        containerView.addSubview(blurView)

        // 2. 초기 상태 설정 (뷰 스프링 효과)
        toView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        toView.center = containerView.center
        toView.alpha = 0.0
        containerView.addSubview(toView)

        // 1. Particle Effect Layer 생성
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: containerView.bounds.midX, y: -10) // 화면 상단 중앙
        emitterLayer.emitterSize = CGSize(width: containerView.bounds.width, height: 600) // 화면의 너비에 맞게 설정
        emitterLayer.emitterShape = .point // 점에서 입자 발사
        emitterLayer.emitterMode = .outline

        // Particle Cell 설정
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(systemName: "pawprint")?.cgImage
        emitterCell.birthRate = 30  // 입자 발생 비율 증가
        emitterCell.spin = 4  // 입자의 회전 속도 증가
        emitterCell.lifetime = 2.5  // 입자의 생명주기 단축
        emitterCell.velocity = 180  // 입자의 초기 속도 증가
        emitterCell.velocityRange = 20  // 속도 범위 증가
        emitterCell.scale = 0.25  // 입자의 초기 크기 감소
        emitterCell.scaleSpeed = 0.05  // 크기 증가 속도 증가
        emitterCell.alphaSpeed = -0.7  // 알파 값 감소 속도 증가
        emitterCell.yAcceleration = 50  // Y 방향으로 중력 효과 추가

        // Particle Cell 설정 (두 번째 입자)
        let emitterCell1 = CAEmitterCell()
        emitterCell1.contents = UIImage(systemName: "pawprint.fill")?.cgImage
        emitterCell1.birthRate = 25  // 입자 발생 비율
        emitterCell1.lifetime = 3  // 입자의 생명주기
        emitterCell1.velocity = 160  // 입자의 초기 속도
        emitterCell1.velocityRange = 15  // 속도 범위
        emitterCell1.scale = 0.4  // 입자의 초기 크기
        emitterCell1.scaleSpeed = 0.04  // 크기 증가 속도
        emitterCell1.alphaSpeed = -0.6  // 알파 값 감소 속도
        emitterCell1.emissionRange = CGFloat.pi * 2  // 입자들이 360도 범위에서 발사
        emitterCell1.yAcceleration = 30  // 중력 효과 추가

        // 2. 입자 셀 추가
        emitterLayer.emitterCells = [emitterCell, emitterCell1]
        toView.layer.addSublayer(emitterLayer)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration * 0.8) {
            blurView.alpha = 1.0
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.3, // 스프링 감쇠 계수
            initialSpringVelocity: 6.0, // 초기 속도
            options: [],
            animations: {
                toView.transform = .identity // 원래 크기
                toView.alpha = 1.0 // 투명도 복원
            },
            completion: { finished in
                transitionContext.completeTransition(finished)
                emitterLayer.removeFromSuperlayer()
            }
        )
    }
}

class SpringBlurTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return SpringBlurAnimator()
    }
}
