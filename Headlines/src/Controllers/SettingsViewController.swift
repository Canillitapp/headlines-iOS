//
//  SettingsViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/01/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    @IBOutlet weak var subscribeButton: UIButton!

    private func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        registerForRemoteNotifications()
    }
}
