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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    
    var newsService = NewsService()
    var newsDataTask: URLSessionDataTask?
    var newsFetched: [Topic]?

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
        
        let success: ([Topic]?) -> () = { (topics) in
            self.newsFetched = topics
            
            let notification = Notification.Name(rawValue:"trendingTopicFinished")
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

        return true
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
}
