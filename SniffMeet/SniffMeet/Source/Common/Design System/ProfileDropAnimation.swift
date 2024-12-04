//
//  ProfileDropAnimation.swift
//  SniffMeet
//
//  Created by 윤지성 on 12/3/24.
//
import UIKit

final class SpringBlurPawEffectAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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

        let emitterLayer = emitterLayer(xValue: containerView.bounds.midX,
                                        yValue: -10,
                                        width: containerView.bounds.width,
                                        height: 500)
        emitterLayer.emitterCells = [pawPrintCell(image: UIImage.navyPaw),
                                     pawPrintCell(image: UIImage.brownPaw)]
        toView.layer.addSublayer(emitterLayer)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration * 0.8) {
            blurView.alpha = 1.0
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.3, // 스프링 감쇠 계수
            initialSpringVelocity: 9.0, // 초기 속도
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
    private func pawPrintCell(image: UIImage) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        emitterCell.contents = image.cgImage
        emitterCell.birthRate = 25  // 입자 발생 비율
        emitterCell.lifetime = 3  // 입자의 생명주기
        emitterCell.velocity = 220  // 입자의 초기 속도
        emitterCell.velocityRange = 40  // 속도 범위
        emitterCell.scale = 0.4  // 입자의 초기 크기
        emitterCell.scaleSpeed = 0.04  // 크기 증가 속도
        emitterCell.alphaSpeed = -0.6  // 알파 값 감소 속도
        emitterCell.emissionRange = CGFloat.pi * 2  // 입자들이 360도 범위에서 발사
        emitterCell.yAcceleration = 30  // 중력 효과 추가
        return emitterCell
    }
    func emitterLayer(xValue: Double,
                      yValue: Double,
                      width: Double,
                      height: Double) -> CAEmitterLayer
    {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: xValue, y: yValue) // 화면 상단 중앙
        emitterLayer.emitterSize = CGSize(width: width, height: height) // 화면의 너비에 맞게 설정
        emitterLayer.emitterShape = .point // 점에서 입자 발사
        emitterLayer.emitterMode = .outline
        return emitterLayer
    }
}

final class ProfileDropTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return SpringBlurPawEffectAnimator()
    }
}
