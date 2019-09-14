//
//  PopularNewsDataSource.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/22/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class PopularNewsDataSource: NewsTableViewControllerDataSource {

    let newsService = NewsService()

    // MARK: NewsTableViewControllerDataSource
    var shouldDisplayPullToRefreshControl = true

    var isFilterEnabled = false

    var isPaginationEnabled = true

    required init() {}

    func fetchNews(page: Int, handler: ((Result <[News], Error>) -> Void)?) {
        newsService.requestPopularNews(page: page, handler: handler)
    }
}
