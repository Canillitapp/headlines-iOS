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
    
    // MARK: Private
    func fetchRequestNews() {
        refreshControl?.beginRefreshing()
        
        newsService.requestRecentNewsWithDate(Date(), success: { (result) in
            
            self.refreshControl?.endRefreshing()
            
            guard let r = result else {
                return
            }
            
            self.news.removeAll()
            self.news.append(contentsOf: r)
            
            self.tableView.reloadData()
            
        }) { (error) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.refreshControl?.endRefreshing()
            }
            
            self.showControllerWithError(error)
        }
    }
    
    // MARK: Public
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Setup refresh control
        let refreshCtrl = UIRefreshControl()
        tableView.refreshControl = refreshCtrl
        
        refreshCtrl.tintColor = UIColor(red:0.99, green:0.29, blue:0.39, alpha:1.00)
        refreshCtrl.addTarget(self, action: #selector(fetchRequestNews), for: .valueChanged)
        
        //  Had to set content offset because of UIRefreshControl bug 
        //  http://stackoverflow.com/a/31224299/994129
        tableView.contentOffset = CGPoint(x:0, y:-refreshCtrl.frame.size.height)
        
        fetchRequestNews()
    }
    
}
