//
//  NewsSearchViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class NewsSearchViewController: NewsTableViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preferredDateStyle = .short
        trackContextFrom = .search
        canFetchMoreNews = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let tableView = tableView else {
            return
        }

        tableView.accessibilityIdentifier = "search table"
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
