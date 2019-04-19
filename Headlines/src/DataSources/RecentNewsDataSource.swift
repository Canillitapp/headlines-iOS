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

    func fetchNews(page: Int, success: (([News]) -> Void)?, fail: ((NSError) -> Void)?) {
        newsService.requestRecentNewsWithDate(Date(), success: { (result) in
            guard let r = result else {
                let userInfo = [
                    NSLocalizedDescriptionKey: "No data"
                ]

                let e = NSError(domain: "RecentNewsDataSource", code: 1, userInfo: userInfo)
                fail?(e)
                return
            }

            success?(r)
        }, fail: fail)
    }
}
