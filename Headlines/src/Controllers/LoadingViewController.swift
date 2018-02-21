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
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private func transitionToNews() {
        DispatchQueue.main.async {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar_controller") else {
                return
            }
            self.controllerSwitcher?.setViewController(vc, animated: true)
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
    
    private func animateBackgroundImageView() {
        backgroundImageView.alpha = 0
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.duration = 1.0
        alphaAnimation.fromValue = 0.0
        alphaAnimation.toValue = 1.0
        alphaAnimation.fillMode = kCAFillModeForwards
        alphaAnimation.isRemovedOnCompletion = false
        alphaAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        backgroundImageView.layer.add(alphaAnimation, forKey: "opacity")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateBackgroundImageView()
        animateLogo()
    }
    
    // MARK: CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionToNews()
    }
}
