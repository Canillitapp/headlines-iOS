//
//  NewsInterfaceController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/24/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import WatchKit
import Foundation

class NewsInterfaceController: WKInterfaceController {

    var news: [News]?

    @IBOutlet var newsTable: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        guard let dict = context as? [String: Any],
            let title = dict["title"] as? String,
            let news = dict["elements"] as? [News] else {
            return
        }

        let sortedNews = news.sorted { $0.date.compare($1.date) == .orderedDescending }

        self.setTitle(title)
        self.newsTable.setNumberOfRows(sortedNews.count, withRowType: "NewsRow")

        for (index, n) in sortedNews.enumerated() {
            let row = self.newsTable.rowController(at: index) as! NewsRowController
            row.titleLabel.setText(n.title)
            row.sourceLabel.setText(n.source)
            row.date = n.date
        }
    }
}
