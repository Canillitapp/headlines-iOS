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
import ViewAnimator

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

        let success: ([News]?) -> Void = { [unowned self] (result) in
            self.loadingIndicator?.hide(animated: true)
            guard let n = result else {
                return
            }
            
            self.news.removeAll()
            self.news.append(contentsOf: n)
            
            self.tableView?.prepareViews()
            
            self.tableView.reloadData()
            
            let animation = AnimationType.from(direction: .right, offset: 10.0)
            self.tableView?.animateViews(
                animations: [animation],
                initialAlpha: 0.0,
                finalAlpha: 1.0,
                delay: 0.0,
                duration: 0.3,
                animationInterval: 0.1,
                completion: nil
            )
        }
        
        let fail: (NSError) -> Void = { [unowned self] (error) in
            self.loadingIndicator?.hide(animated: true)
            self.showControllerWithError(error)
        }
        
        newsService.searchNews(text, success: success, fail: fail)
        
        Answers.logSearch(withQuery: text, customAttributes: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.preferredDateStyle = .short
        
        Answers.logCustomEvent(withName: "search_appear", customAttributes: nil)
        
        searchBar.becomeFirstResponder()
    }
}
