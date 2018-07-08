//
//  NewsSearchViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import Crashlytics
import ViewAnimator

class NewsSearchViewController: NewsTableViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        preferredDateStyle = .short
        trackContextFrom = .search
        tableView.accessibilityIdentifier = "search table"
        Answers.logCustomEvent(withName: "search_appear", customAttributes: nil)
    }

    func show(news: [News]?) {
        guard let news = news else {
            return
        }
        self.news = news
        self.tableView.reloadData()
        self.tableView?.animateViews(
            animations: [AnimationType.from(direction: .right, offset: 10.0)],
            animationInterval: 0.1
        )
    }
        
    func resetNews() {
        news.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
