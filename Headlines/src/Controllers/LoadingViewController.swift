//
//  LoadingViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/6/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trendingService = NewsService()
        let _ = trendingService.requestTrendingTopicsWithDate(Date(), count: 6, success: { (topics) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar_controller") as? InitialTabBarController else {
                    return
                }
                
                vc.trendingTopics = topics
                self.controllerSwitcher?.setViewController(vc, animator: FadeTransition())
            })
            
        }, fail: { (error) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tab_bar_controller") else {
                    return
                }
                self.controllerSwitcher?.setViewController(vc, animator: FadeTransition())
            })
        })
    }
}
