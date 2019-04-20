//
//  LoadingViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/6/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var apiCallCompletionObserver: NSObjectProtocol?
    
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
        alphaAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        positionAnimation.duration = 0.5
        positionAnimation.values = [-15, 0]
        positionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, alphaAnimation]
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.duration = 1.8
        logoImageView.layer.add(groupAnimation, forKey: "group")
    }
    
    private func animateBackgroundImageView() {
        backgroundImageView.alpha = 0
        
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.duration = 1.0
        alphaAnimation.fromValue = 0.0
        alphaAnimation.toValue = 1.0
        alphaAnimation.fillMode = CAMediaTimingFillMode.forwards
        alphaAnimation.isRemovedOnCompletion = false
        alphaAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        backgroundImageView.layer.add(alphaAnimation, forKey: "opacity")
    }
    
    private func catchNotification(notification: Notification) {
        DispatchQueue.main.async { [unowned self] in
            self.transitionToNews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiCallCompletionObserver = NotificationCenter.default.addObserver(
                forName: Notification.Name(rawValue: "loadingTaskFinished"),
                object: nil,
                queue: nil,
                using: catchNotification
        )
        
        animateBackgroundImageView()
        animateLogo()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(apiCallCompletionObserver)
    }
}
