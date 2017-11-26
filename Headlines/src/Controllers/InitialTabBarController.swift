//
//  InitialTabBarController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/22/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class InitialTabBarController: OrientationAwareTabBarController {
    
    var trendingTopics: [Topic]?
    
    func navigationControllerFrom(_ controller: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.barStyle = .black
        navController.navigationBar.isTranslucent = false
        
        let font = UIFont(name: "Rubik-Regular", size: 18)
        if let font = font {
            navController.navigationBar.titleTextAttributes = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: UIColor.white
            ]
        }
        
        return navController
    }
    
    func trendingTabViewController() -> UIViewController? {
        let trendingStoryboard = UIStoryboard(name: "Trending", bundle: Bundle.main)
        guard
            let nav = trendingStoryboard.instantiateInitialViewController() as? UINavigationController,
            let vc = nav.topViewController as? TrendingCardsViewController,
            let topics = trendingTopics else {
                
                return trendingStoryboard.instantiateInitialViewController()
        }
        
        vc.topics = topics
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
        
        return navigationControllerFrom(recentsViewController)
    }
    
    func myReactionsTabViewController() -> UIViewController? {
        let myReactionsStoryboard = UIStoryboard(name: "MyReactions",
                                                 bundle: Bundle.main)
        return myReactionsStoryboard.instantiateInitialViewController()
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
        
        //  "Reacciones" tab
        if let myReactionsViewController = myReactionsTabViewController() {
            controllers.append(myReactionsViewController)
        }
        
        return controllers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers(initialControllers(), animated: true)
    }
}
