//
//  UIViewController + Child.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 08/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        let childView = child.view
        childView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childView!)
        NSLayoutConstraint.activate([
            childView!.topAnchor.constraint(equalTo: _safeAreaLayoutGuide.topAnchor),
            childView!.leftAnchor.constraint(equalTo: _safeAreaLayoutGuide.leftAnchor),
            childView!.bottomAnchor.constraint(equalTo: _safeAreaLayoutGuide.bottomAnchor),
            childView!.rightAnchor.constraint(equalTo: _safeAreaLayoutGuide.rightAnchor)
            ])
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    //swiftlint: disable: all
    private var _safeAreaLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide
        } else {
            let id = "ft_safeAreaLayoutGuide"
            
            if let layoutGuide = view.layoutGuides.filter({ $0.identifier == id }).first {
                return layoutGuide
            } else {
                let layoutGuide = UILayoutGuide()
                layoutGuide.identifier = id
                view.addLayoutGuide(layoutGuide)
                layoutGuide.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
                layoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                layoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                layoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
                return layoutGuide
            }
        }
    }
}
