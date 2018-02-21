//
//  ScreenSwitcherViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/6/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class ScreenSwitcherViewController: OrientationAwareViewController {

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
        
        setViewController(vc, animated: false)
    }
    
    func setViewController(_ viewcontroller: UIViewController, animated: Bool) {
        DispatchQueue.main.async { [unowned self] in
            
            self.currentViewController?.willMove(toParentViewController: nil)
            self.addChildViewController(viewcontroller)
            self.view.addSubview(viewcontroller.view)
            
            let completion: (Bool) -> Void = { [weak self] completed in
                guard let vc = self else {
                    return
                }
                
                vc.currentViewController?.view.removeFromSuperview()
                vc.currentViewController?.removeFromParentViewController()
                viewcontroller.didMove(toParentViewController: self)
                
                vc.currentViewController = viewcontroller
                vc.setNeedsStatusBarAppearanceUpdate()
            }
            
            if animated {
                viewcontroller.view.alpha = 0.0
                
                let animation: () -> Void = {
                    viewcontroller.view.alpha = 1.0
                }
                
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    options: [],
                    animations: animation,
                    completion: completion
                )
                
            } else {
                completion(true)
            }
        }
    }
}
