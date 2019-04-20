//
//  InitialTabBarController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/22/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices

class InitialTabBarController: UITabBarController, UITabBarControllerDelegate {
    var lastSelectedTabBarItem: String?
    var tabs = [String: UIViewController]()

    // Used to handle push notifications with news attached
    var newsToOpen: News?

    func navigationControllerFrom(_ controller: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.barStyle = .black
        navController.navigationBar.isTranslucent = false

        let font = UIFont(name: "Rubik-Regular", size: 18)
        if let font = font {
            navController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        }

        return navController
    }

    func trendingTabViewController() -> UIViewController? {
        let trendingStoryboard = UIStoryboard(name: "Trending", bundle: Bundle.main)
        guard
            let nav = trendingStoryboard.instantiateInitialViewController() as? UINavigationController,
            let vc = nav.topViewController as? TrendingCardsViewController else {

                return trendingStoryboard.instantiateInitialViewController()
        }

        if let t = NewsManager.sharedInstance.topics {
            vc.topics.append(contentsOf: t)
        }

        return nav
    }

    func popularTabViewController() -> UIViewController? {
        let newsStoryboard = UIStoryboard(name: "News", bundle: Bundle.main)

        guard let popularViewController = newsStoryboard.instantiateViewController(withIdentifier: "news")
            as? NewsTableViewController else {
                return nil
        }

        popularViewController.newsDataSource = PopularNewsDataSource()

        let popularBarItem = UITabBarItem(title: "Popular",
                                          image: UIImage(named: "popular_icon"),
                                          selectedImage: nil)
        popularViewController.tabBarItem = popularBarItem
        popularViewController.title = "Popular"
        popularViewController.analyticsIdentifier = "popular"
        popularViewController.preferredDateStyle = .short
        popularViewController.trackContextFrom = .popular

        return navigationControllerFrom(popularViewController)
    }

    func recentsTabViewController() -> UIViewController? {
        let newsStoryboard = UIStoryboard(name: "News", bundle: Bundle.main)

        guard let recentsViewController = newsStoryboard.instantiateViewController(withIdentifier: "news")
            as? NewsTableViewController else {
                return nil
        }

        recentsViewController.newsDataSource = RecentNewsDataSource()

        let recentsTabBarItem = UITabBarItem(title: "Reciente",
                                             image: UIImage(named: "recents_icon"),
                                             selectedImage: nil)
        recentsViewController.tabBarItem = recentsTabBarItem
        recentsViewController.title = "Reciente"
        recentsViewController.analyticsIdentifier = "recent"
        recentsViewController.trackContextFrom = .recent

        return navigationControllerFrom(recentsViewController)
    }

    func profileTabViewController() -> UIViewController? {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        return profileStoryboard.instantiateInitialViewController()
    }

    func searchTabViewController() -> UIViewController? {
        let searchStoryboard = UIStoryboard(name: "Search", bundle: Bundle.main)
        return searchStoryboard.instantiateInitialViewController()
    }

    func initialControllers() -> [UIViewController] {
        var controllers: [UIViewController] = []

        // "Destacados" tab
        if let trendingViewController = trendingTabViewController() {
            controllers.append(trendingViewController)
        }

        // "Popular" tab
        if let popularViewController = popularTabViewController() {
            controllers.append(popularViewController)
        }

        // "Reciente" tab
        if let recentsViewController = recentsTabViewController() {
            controllers.append(recentsViewController)
        }

        // "Buscar" tab
        if let searchViewController = searchTabViewController() {
            controllers.append(searchViewController)
        }

        //  "Perfil" tab
        if let profileViewController = profileTabViewController() {
            controllers.append(profileViewController)
        }

        return controllers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let controllers = initialControllers()
        setViewControllers(controllers, animated: true)
        delegate = self

        /*  generate a map [String: UIViewController], so it will be easy
         *  to recognize which viewcontroller has been double tapped
         */
        controllers.forEach { tabs[$0.tabBarItem.title!] = $0 }
        lastSelectedTabBarItem = "Destacados"

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentNews(notification:)),
                                               name: .notificationNewsTapped,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .notificationNewsTapped, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentNewsIfNecessary()
    }

    // MARK: UITabBarControllerDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let title = item.title else {
            return
        }

        if lastSelectedTabBarItem == title {
            if let nav = tabs[title] as? UINavigationController,
                let vc = nav.topViewController as? TabbedViewController {
                vc.tabbedViewControllerWasDoubleTapped()
            }
        }
        lastSelectedTabBarItem = title
    }
}

// MARK: Handling push notifications

/**
 *  When a user taps a notification with a news, the app opens it
 *  on a SFSafariViewController
 */

extension InitialTabBarController: SFSafariViewControllerDelegate {

    fileprivate func presentNews(_ news: News) {
        let vc = SFSafariViewController(url: news.url, entersReaderIfAvailable: true)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    @objc fileprivate func presentNews(notification: Notification) {
        guard let n = notification.object as? News else {
            return
        }

        newsToOpen = n

        presentNews(n)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.newsToOpen = nil
    }

    fileprivate func presentNewsIfNecessary() {
        /**
         *  did the user tap a push notification with a news?
         *  open it on a modal.
         */

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        newsToOpen = appDelegate.newsToOpen

        if let n = newsToOpen {
            presentNews(n)
        }

        appDelegate.newsToOpen = nil
    }

    // MARK: SFSafariViewControllerDelegate
    func safariViewController(_ controller: SFSafariViewController,
                              activityItemsFor URL: URL,
                              title: String?) -> [UIActivity] {

        guard let n = newsToOpen  else {
            return []
        }

        let activity = ShareCanillitapActivity(withNews: n)
        return [activity]
    }
}
