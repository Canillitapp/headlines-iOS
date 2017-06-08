//
//  SearchViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/27/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Crashlytics

class SearchViewController: NewsTableViewController, UISearchBarDelegate {
    
    let newsService = NewsService()
    
    var loadingIndicator: MBProgressHUD?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text else {
            return
        }
        
        loadingIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingIndicator?.mode = .indeterminate

        newsService.searchNews(text, success: { (news) in
            self.loadingIndicator?.hide(animated: true)
            guard let n = news else {
                return
            }
            
            self.news.removeAll()
            self.news.append(contentsOf: n)
            self.tableView.reloadData()
            
        }) { (error) in
            self.loadingIndicator?.hide(animated: true)
            
            self.showControllerWithError(error)
        }
        
        Answers.logSearch(withQuery: text, customAttributes: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Answers.logCustomEvent(withName: "search_appear", customAttributes: nil)
    }
}
