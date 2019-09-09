//
//  RecentNewsDataSource.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/22/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class RecentNewsDataSource: NewsTableViewControllerDataSource {

    let newsService = NewsService()

    // MARK: NewsTableViewControllerDataSource
    var shouldDisplayPullToRefreshControl = true

    var isFilterEnabled = true

    var isPaginationEnabled = false

    func fetchNews(page: Int, handler: ((_ result: Result <[News], Error>) -> Void)?) {
        newsService.requestRecentNewsWithDate(Date(), handler: handler)
    }
}
