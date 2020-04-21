//
//  File.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 20/04/2020.
//  Copyright © 2020 Ezequiel Becerra. All rights reserved.
//

import Foundation

class SearchNewsDataSource: NewsTableViewControllerDataSource {

    let newsService = NewsService()

    // MARK: NewsTableViewControllerDataSource
    var shouldDisplayPullToRefreshControl = true

    var isFilterEnabled = false

    var isPaginationEnabled = true

    let searchTerm: String

    required init(searchTerm: String) {
        self.searchTerm = searchTerm
    }

    func fetchNews(page: Int, handler: ((_ result: Result <[News], Error>) -> Void)?) {
        _ = newsService.searchNews(searchTerm, page: page, handler: handler)
    }
}
