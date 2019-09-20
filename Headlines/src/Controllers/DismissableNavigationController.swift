//
//  DismissableNavigationController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 29/11/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class DismissableNavigationController: UINavigationController {

    var dismissButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(selfDismiss))
    }

    @objc func selfDismiss() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Styling
        navigationBar.tintColor = UIColor.systemBackground
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = false

        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Rubik-Regular", size: 18)!
        ]

        navigationBar.titleTextAttributes = attributes
    }

}
