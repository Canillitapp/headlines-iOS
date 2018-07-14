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
        let move = AnimationType.from(direction: .bottom, offset: 5)
        let scale = AnimationType.zoom(scale: 0.98)
        UIView.animate(
            views: tableView.visibleCells,
            animations: [move, scale]
        )
    }
        
    func resetNews() {
        news.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
