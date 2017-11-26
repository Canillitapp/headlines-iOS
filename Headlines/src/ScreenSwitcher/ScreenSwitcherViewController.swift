//
//  ScreenSwitcherViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/6/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class ScreenSwitcherViewController: UIViewController {

    public var initialViewController: String?
    
    public var currentViewController: UIViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch currentViewController {
        case let tabBarController as UITabBarController:
            guard let selectedViewController = tabBarController.selectedViewController else {
                return .default
            }
            return selectedViewController.preferredStatusBarStyle
        
        case let navController as UINavigationController:
            guard let topController = navController.topViewController else {
                return .default
            }
            return topController.preferredStatusBarStyle
        
        default:
            guard let controller = currentViewController else {
                return .default
            }
            return controller.preferredStatusBarStyle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let identifier = initialViewController,
            let vc = storyboard?.instantiateViewController(withIdentifier: identifier) else {
                
                return
        }
        
        setViewController(vc, animator: nil)
    }
    
    func setViewController(_ viewcontroller: UIViewController, animator: UIViewControllerAnimatedTransitioning?) {
        DispatchQueue.main.async { [unowned self] in
            if animator == nil {
                //  No animator, so there's no transition
                self.willMove(toParentViewController: nil)
                self.addChildViewController(viewcontroller)
                self.view.addSubview(viewcontroller.view)
                
                self.currentViewController?.view.removeFromSuperview()
                self.currentViewController?.removeFromParentViewController()
                viewcontroller.didMove(toParentViewController: self)
                
                self.currentViewController = viewcontroller
                self.setNeedsStatusBarAppearanceUpdate()
                
            } else {
                //  Will use an animator
                self.willMove(toParentViewController: nil)
                self.addChildViewController(viewcontroller)
                
                let transitionContext = TransitionContext(from: self.currentViewController!, to: viewcontroller)
                transitionContext.completionHandler = { (didComplete: Bool) -> Void in
                    
                    self.currentViewController?.view.removeFromSuperview()
                    self.currentViewController?.removeFromParentViewController()
                    viewcontroller.didMove(toParentViewController: self)
                    
                    //  If animator implements animationEnded: call it
                    animator!.animationEnded?(didComplete)
                    
                    self.currentViewController = viewcontroller
                    self.setNeedsStatusBarAppearanceUpdate()
                }
                
                animator?.animateTransition(using: transitionContext)
            }
        }
    }
}
