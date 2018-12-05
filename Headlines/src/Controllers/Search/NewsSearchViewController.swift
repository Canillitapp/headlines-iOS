//
//  NewsSearchViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import ViewAnimator

class NewsSearchViewController: NewsTableViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preferredDateStyle = .short
        trackContextFrom = .search
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let tableView = tableView else {
            return
        }
        
        tableView.accessibilityIdentifier = "search table"
    }

    func show(news: [News]?) {
        guard let news = news else {
            return
        }
        self.news = news
        
        guard let tableView = tableView else {
            return
        }
        
        tableView.reloadData()
        let move = AnimationType.from(direction: .bottom, offset: 5)
        let scale = AnimationType.zoom(scale: 0.98)
        UIView.animate(
            views: tableView.visibleCells,
            animations: [move, scale]
        )
    }
        
    func resetNews() {
        news.removeAll()
        
        guard let tableView = tableView else {
            return
        }
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}
