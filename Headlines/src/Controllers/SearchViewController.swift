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

class SearchViewController: NewsTableViewController, UISearchBarDelegate {
    
    let newsService = NewsService()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //  MARK: Public
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //  MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text else {
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        newsService.searchNews(text, success: { (news) in
            MBProgressHUD.hide(for: self.view, animated: true)
            guard let n = news else {
                return
            }
            
            self.news.removeAll()
            self.news.append(contentsOf: n)
            self.tableView.reloadData()
            
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("\(error.localizedDescription)")
        }
    }
}
