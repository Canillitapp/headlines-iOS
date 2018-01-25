//
//  AppDelegate.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder,
                    UIApplicationDelegate,
                    UISplitViewControllerDelegate,
                    UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    var newsService = NewsService()
    var newsDataTask: URLSessionDataTask?
    var newsFetched: [Topic]?
    var userSettingsManager = UserSettingsManager()

    func registerForRemoteNotifications(with application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    application.registerForRemoteNotifications()
                }
                
                if error != nil {
                    print("#ERROR: \(error?.localizedDescription ?? "unknown")")
                }
            }
        }
    }
    
    func setupNotifications() {
        let viewAction = UNNotificationAction(identifier: "view", title: "Ver", options: [.foreground])
        let likeAction = UNNotificationAction(identifier: "like", title: "👍", options: [])
        let dislikeAction = UNNotificationAction(identifier: "dislike", title: "👎", options: [])
        
        let newsAPNCategory = UNNotificationCategory(
            identifier: "news_apn",
            actions: [viewAction, likeAction, dislikeAction],
            intentIdentifiers: [],
            options: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([newsAPNCategory])
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //  https://www.herzbube.ch/blog/2016/08/how-hide-fabric-api-key-and-build-secret-open-source-project
        let resourceURL = Bundle.main.url(forResource: "fabric", withExtension: "apikey")
        
        do {
            var fabricAPIKey = try String(contentsOf: resourceURL!)
            fabricAPIKey = fabricAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
            if fabricAPIKey != "" {
                Crashlytics.start(withAPIKey: fabricAPIKey)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        if userSettingsManager.firstOpenDate == nil {
            userSettingsManager.firstOpenDate = Date()
        }
        
        let success: ([Topic]?) -> Void = { (topics) in
            self.newsFetched = topics
            
            let notification = Notification.Name(rawValue: "trendingTopicFinished")
            let nc = NotificationCenter.default
            nc.post(
                name: notification,
                object: nil,
                userInfo: ["topics": topics!]
            )
        }
        
        newsDataTask = newsService.requestTrendingTopicsWithDate(
            Date(),
            count: 6,
            success: success,
            fail: nil
        )
        
        registerForRemoteNotifications(with: application)
        setupNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("#ERROR: \(error.localizedDescription)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
// MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let postId = response.notification.request.content.userInfo["post-id"] as? String else {
            return
        }
        print("#DEBUG \(response.actionIdentifier) - \(postId)")
        
        completionHandler()
    }
    
}
