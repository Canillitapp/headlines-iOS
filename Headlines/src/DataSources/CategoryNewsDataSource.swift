//
//  CategoryNewsDataSource.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 04/02/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class CategoryNewsDataSource: NewsTableViewControllerDataSource {
    let newsService = NewsService()
    
    // MARK: NewsTableViewControllerDataSource
    var shouldDisplayPullToRefreshControl = true
    
    var isFilterEnabled = true
    
    func fetchNews(success: ((_: [News]) -> Void)?, fail: ((_ error: NSError) -> Void)?) {
        newsService.requestFromCategory("4", success: { (result) in
            guard let r = result else {
                let userInfo = [
                    NSLocalizedDescriptionKey: "No data"
                ]
                
                let e = NSError(domain: "CategoryNewsDataSource", code: 1, userInfo: userInfo)
                fail?(e)
                return
            }
            
            success?(r)
        }, fail: fail)
    }
}
