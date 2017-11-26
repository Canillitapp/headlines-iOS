//
//  FadeTransition.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //  Get the two viewcontrollers
        let from = transitionContext.viewController(forKey: .from)
        let to = transitionContext.viewController(forKey: .to)
        
        guard
            let fromView = from?.view,
            let toView = to?.view else {
                transitionContext.completeTransition(true)
                return
        }
        
        //  Get the container view - where the animation happens
        let containerView = transitionContext.containerView
        
        //  Add the two viewcontroller views to the container
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        toView.alpha = 0.0
        
        let animation: () -> Void = {
            toView.alpha = 1.0
        }
        
        let completion: (Bool) -> Void = { (finished) in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            delay: 0,
            options: [],
            animations: animation,
            completion: completion
        )
    }
}
