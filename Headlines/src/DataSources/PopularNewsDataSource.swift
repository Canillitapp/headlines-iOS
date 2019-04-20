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

    func fetchNews(page: Int, success: ((_: [News]) -> Void)?, fail: ((_ error: NSError) -> Void)?) {

        let success: (([News]?) -> Void) = { result in
            guard let r = result else {
                let userInfo = [
                    NSLocalizedDescriptionKey: "No data"
                ]

                let e = NSError(domain: "PopularNewsDataSource", code: 1, userInfo: userInfo)
                fail?(e)
                return
            }

            success?(r)
        }

        newsService.requestPopularNews(page: page, success: success, fail: fail)
    }
}
