//
//  UIViewController+Switcher.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

extension UIViewController {
    var controllerSwitcher: ScreenSwitcherViewController? {
        get {
            var parentViewController = self.parent
            while parentViewController != nil && !parentViewController!.isMember(of: ScreenSwitcherViewController.self) {
                parentViewController = parentViewController?.parent
            }
            return parentViewController as? ScreenSwitcherViewController
        }
    }
}
