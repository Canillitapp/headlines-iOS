//
//  DimPresentAnimationController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/15/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

let kContainerStackViewDistance: CGFloat = 250.0
let kAnimationDurationPresent: TimeInterval = 0.60
let kAnimationDurationDismiss: TimeInterval = 0.30

class DimPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting: Bool = false

    private func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }

        let animationClosure: (() -> Void) = {
            fromVC.view.alpha = 0

            if let filterVC = fromVC as? FilterViewController {
                filterVC.containerStackView.transform = CGAffineTransform(translationX: 0,
                                                                          y: kContainerStackViewDistance)
            }
        }

        let completionClosure: ((Bool) -> Void) = { (_) in
            transitionContext.completeTransition(true)
        }

        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseInOut,
            animations: animationClosure,
            completion: completionClosure
        )
    }

    private func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0

        if let filterVC = toVC as? FilterViewController {
            filterVC.containerStackView.transform = CGAffineTransform(translationX: 0, y: kContainerStackViewDistance)
        }

        let animationClosure: (() -> Void) = {
            toVC.view.alpha = 1

            if let filterVC = toVC as? FilterViewController {
                filterVC.containerStackView.transform = CGAffineTransform.identity
            }
        }

        let completionClosure: ((Bool) -> Void) = { (_) in
            transitionContext.completeTransition(true)

            guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
                return
            }
            keyWindow.addSubview(toVC.view)
        }

        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: animationClosure,
            completion: completionClosure
        )
    }

    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? kAnimationDurationPresent : kAnimationDurationDismiss
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentAnimation(using: transitionContext)
        } else {
            dismissAnimation(using: transitionContext)
        }
    }
}
