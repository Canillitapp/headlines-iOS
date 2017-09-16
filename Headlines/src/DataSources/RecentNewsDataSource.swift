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
    
    func fetchNews(success: ((_: [News]) -> Void)?, fail: ((_ error: NSError) -> Void)?) {
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
