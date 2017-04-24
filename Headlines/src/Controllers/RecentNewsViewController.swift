//
//  RecentNewsViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 12/9/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit

class RecentNewsViewController: NewsTableViewController {

    let newsService = NewsService()
    
    //  MARK: Public
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsService.requestRecentNewsWithDate(Date(), success: { (result) in
            
            guard let r = result else {
                return
            }
            
            self.news.append(contentsOf: r)
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(":-(")
        }
    }
    
}
