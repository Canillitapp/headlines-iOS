//
//  OrientationAwareControllers.swift
//  Headlines
//
//  Created by Julio Carrettoni on 5/4/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class OrientationAwareTabBarController: UITabBarController {
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        } else {
            return .portrait
        }
    }
    
    override var shouldAutorotate: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
