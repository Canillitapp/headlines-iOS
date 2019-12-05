//
//  AppDelegate.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import UserNotifications

import JGProgressHUD

extension Notification.Name {
    static let notificationNewsTapped = Notification.Name("notification_news_tapped")
}

@UIApplicationMain
class AppDelegate: UIResponder,
                    UIApplicationDelegate,
                    UISplitViewControllerDelegate,
                    UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let reactionsService = ReactionsService()
    let usersService = UsersService()
    let newsService = NewsService()
    var newsDataTask: URLSessionDataTask?
    var newsFetched: [Topic]?
    let userSettingsManager = UserSettingsManager()
    var newsToOpen: News?

    var loadingTask: LoadingTask?

    func registerNotificationActions() {
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

    func setupNotifications() {
        registerNotificationActions()

        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func retryFetchCategoriesAndNewsAlert(with error: Error) {
        var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.windowLevel = UIWindow.Level.alert + 1

        let alert = UIAlertController(
            title: "Whoops",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let retry = UIAlertAction(
            title: "Volver a intentar",
            style: .default) { [unowned self] (_) in
                self.fetchCategoriesAndNews()
                window?.isHidden = true
                window = nil
        }
        alert.addAction(retry)

        window?.makeKeyAndVisible()
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func fetchCategoriesAndNews() {
        let completion: ([Topic]?, [Category]?, Error?) -> Void = { [unowned self] (topics, categories, error) in
            if let e = error {
                print("#ERROR: \(e.localizedDescription)")
                self.retryFetchCategoriesAndNewsAlert(with: e)
                return
            }

            guard let t = topics, let c = categories else {
                let e = NSError(
                    domain: "Startup",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Something went wrong"]
                )
                print("#ERROR: \(e.localizedDescription)")
                self.retryFetchCategoriesAndNewsAlert(with: e)
                return
            }

            NewsManager.sharedInstance.categories = c
            NewsManager.sharedInstance.topics = t

            let notification = Notification.Name(rawValue: "loadingTaskFinished")
            let nc = NotificationCenter.default
            nc.post(name: notification, object: nil, userInfo: nil)
        }

        loadingTask = LoadingTask(with: completion)
        loadingTask?.start()
    }

    func presentSearchController(topic: String) {

        guard
            let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first ,
            let vc = keyWindow.rootViewController else {
            return
        }

        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: vc.view)

        let handler: ((Result <[News], Error>) -> Void) = { result in
            switch result {
            case .success(let news):
                hud.dismiss()

                let storyboard = UIStoryboard.init(name: "News", bundle: Bundle.main)
                guard let newsViewController = storyboard.instantiateViewController(withIdentifier: "news")
                    as? NewsTableViewController else {
                        return
                }
                newsViewController.preferredDateStyle = .short
                newsViewController.trackContextFrom = .search
                newsViewController.news = news
                newsViewController.title = topic

                let navController = DismissableNavigationController(rootViewController: newsViewController)
                newsViewController.navigationItem.leftBarButtonItem = navController.dismissButtonItem

                vc.present(navController, animated: true, completion: nil)

            case .failure:
                hud.dismiss()
            }
        }

        let newsService = NewsService()
        _ = newsService.searchNews(topic, handler: handler)
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if userSettingsManager.firstOpenDate == nil {
            userSettingsManager.firstOpenDate = Date()
        }

        fetchCategoriesAndNews()

        setupNotifications()

        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        if userActivity.activityType == SuggestionsHelper.ActivityType.search.rawValue {

            guard let topic = userActivity.userInfo?["topic"] as? String else {
                return false
            }

            presentSearchController(topic: topic)

            return true
        }
        return false
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        usersService.postDeviceToken(token, handler: nil)
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

        guard let postId = response.notification.request.content.userInfo["post-id"] as? Int else {
            completionHandler()
            return
        }

        switch response.actionIdentifier {
        case "like":
            reactionsService.postReaction("👍", atPost: "\(postId)", handler: nil)
        case "dislike":
            reactionsService.postReaction("👎", atPost: "\(postId)", handler: nil)

        //  Responds "view" action and default one
        default:

            guard
                let postURLString = response.notification.request.content.userInfo["post-url"] as? String,
                let postURL = URL(string: postURLString) else {
                    return
            }

            newsToOpen = News(identifier: "\(postId)", url: postURL, title: "Noticia", date: Date())
            NotificationCenter.default.post(name: .notificationNewsTapped, object: newsToOpen)
        }

        completionHandler()
    }

}
