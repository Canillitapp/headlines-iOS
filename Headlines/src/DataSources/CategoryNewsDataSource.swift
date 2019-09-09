//
//  CategoryNewsDataSource.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class CategoryNewsDataSource: NewsTableViewControllerDataSource {

    let newsService = NewsService()

    // MARK: NewsTableViewControllerDataSource
    var shouldDisplayPullToRefreshControl = true

    var isFilterEnabled = false

    var isPaginationEnabled = true

    let category: Category

    required init(category: Category) {
        self.category = category
    }

    func fetchNews(page: Int, handler: ((_ result: Result <[News], Error>) -> Void)?) {
        newsService.requestFromCategory(category.identifier, page: page, handler: handler)
    }
}
