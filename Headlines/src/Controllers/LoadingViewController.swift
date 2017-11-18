//
//  LoadingViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/6/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    
    private func transitionToNews() {
        DispatchQueue.main.async {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar_controller") else {
                return
            }
            self.controllerSwitcher?.setViewController(vc, animator: FadeTransition())
        }
    }
    
    private func animateLogo() {
        let alphaAnimation = CAKeyframeAnimation(keyPath: "opacity")
        alphaAnimation.duration = 1.8
        alphaAnimation.values = [0, 1, 1, 0]
        alphaAnimation.keyTimes = [0, 0.05, 0.90, 1]
        alphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        positionAnimation.duration = 0.5
        positionAnimation.values = [-15, 0]
        positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, alphaAnimation]
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.duration = 1.8
        groupAnimation.delegate = self
        logoImageView.layer.add(groupAnimation, forKey: "group")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLogo()
    }
    
    // MARK: CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionToNews()
    }
}
