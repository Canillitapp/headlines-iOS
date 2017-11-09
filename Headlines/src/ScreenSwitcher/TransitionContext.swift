//
//  TransitionContext.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/7/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class TransitionContext: NSObject, UIViewControllerContextTransitioning {
    var containerView: UIView
    
    var viewControllers: [UITransitionContextViewControllerKey: UIViewController]?
    
    var isAnimated: Bool {
        //  Always animated
        return true
    }
    
    var isInteractive: Bool {
        //  Interactive transitions are not supported
        return false
    }
    
    var transitionWasCancelled: Bool {
        //  Interactive transitions are not supported
        return false
    }
    
    var presentationStyle: UIModalPresentationStyle {
        return .custom
    }
    
    var targetTransform: CGAffineTransform {
        return CGAffineTransform.identity
    }
    
    var completionHandler: ((_ animated: Bool) -> ())?
    
    init(from fromViewController: UIViewController, to toViewController: UIViewController) {
        containerView = fromViewController.view.superview!
        viewControllers = [
            .from: fromViewController,
            .to: toViewController
        ]
    }
    
    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        //  Interactive transitions are not supported
    }
    
    func finishInteractiveTransition() {
        //  Interactive transitions are not supported
    }
    
    func cancelInteractiveTransition() {
        //  Interactive transitions are not supported
    }
    
    func pauseInteractiveTransition() {
        //  Interactive transitions are not supported
    }
    
    func completeTransition(_ didComplete: Bool) {
        guard let handler = completionHandler else {
            return
        }
        
        handler(didComplete)
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return viewControllers?[key]
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return nil
    }
    
    func initialFrame(for vc: UIViewController) -> CGRect {
        return vc.view.frame
    }
    
    func finalFrame(for vc: UIViewController) -> CGRect {
        return vc.view.frame
    }
}
