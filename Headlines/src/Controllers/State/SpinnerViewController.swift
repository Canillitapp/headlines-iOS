//
//  SpinnerViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 08/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}
