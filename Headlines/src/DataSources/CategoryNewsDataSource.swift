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
    
    let category: Category
    
    required init(category: Category) {
        self.category = category
    }
    
    func fetchNews(success: ((_: [News]) -> Void)?, fail: ((_ error: NSError) -> Void)?) {
        newsService.requestFromCategory(category.identifier, success: { (result) in
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
