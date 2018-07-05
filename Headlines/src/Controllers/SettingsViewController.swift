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

    // MARK: - IBOutlets
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var subscribeLabel: UILabel!

    // MARK: - Properties
    var userNotificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Init & Deinit
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // We add an observer for .UIApplicationWillEnterForeground as the
        // UI needs updating if the user modifies the notification permissons
        // from the app page on iOS Settings while this ViewController exists.
        registerApplicationWillEnterForeground()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    @objc func layout() {
        userNotificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied:
                self.layoutAskForNotifications()
            case .authorized:
                self.layoutNotificationsAuthorized()
            }
        }
    }
    
    private func layoutAskForNotifications() {
        DispatchQueue.main.async {
            self.subscribeButton.isEnabled = true
            self.subscribeButton.setTitle("Suscribirse a notificaciones",
                                          for: .normal)
            self.subscribeLabel.text =
            "Al suscribirte, recibirás una notificación sobre una noticia importante una vez al día"
        }
    }
    
    private func layoutNotificationsAuthorized() {
        DispatchQueue.main.async {
            self.subscribeButton.isEnabled = false
            self.subscribeButton.setTitle("✅",
                                          for: .normal)
            self.subscribeLabel.text =
            "Ya estas suscripto! Estarás recibiendo una notificación sobre una noticia importante una vez al dia."
        }
    }
    
    private func checkRemoteNotificationsStatus() {
        userNotificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Push notifications permissions haven't been asked yet.
                self.registerForRemoteNotifications()
            case .denied:
                // Push notifications where denied so we open the app page
                // on iOS Settings.
                DispatchQueue.main.async {
                    let url = URL(string: UIApplicationOpenSettingsURLString)!
                    UIApplication.shared.open(url)
                }
            case .authorized:
                assertionFailure("Suscribe button was enabled while the notifications where already authorized.")
                self.layoutNotificationsAuthorized()
            }
        }
    }

    private func registerForRemoteNotifications() {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                    self.layoutNotificationsAuthorized()
                }
            }
        }
    }
    
    @IBAction func subscribeButtonPressed(_ sender: Any) {
        checkRemoteNotificationsStatus()
    }
    
    private func registerApplicationWillEnterForeground() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.layout),
            name: Notification.Name.UIApplicationWillEnterForeground,
            object: nil
        )
    }
}
