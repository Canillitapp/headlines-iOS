//
//  NewsSearchViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import Crashlytics
import ViewAnimator

class NewsSearchViewController: NewsTableViewController, Searchable {
    
    private let newsService = NewsService()
    private var dataTask: URLSessionDataTask?
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        preferredDateStyle = .short
        trackContextFrom = .search
        tableView.accessibilityIdentifier = "search table"
        Answers.logCustomEvent(withName: "search_appear", customAttributes: nil)
    }
    
    func search(text: String?) {
        guard let text = text, !text.isEmpty else { return }
        activityIndicator.startAnimating()
        dataTask?.cancel()
        
        let success: ([News]?) -> Void = { [unowned self] (result) in
            guard let n = result else {
                return
            }
            
            self.news.removeAll()
            self.news.append(contentsOf: n)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                let animation = AnimationType.from(direction: .right, offset: 10.0)
                self.tableView?.animateViews(animations: [animation],
                                             animationInterval: 0.1)
            }
        }
        
        let fail: (NSError) -> Void = { [unowned self] (error) in
            self.activityIndicator.stopAnimating()
            self.showControllerWithError(error)
        }
        
        dataTask = newsService.searchNews(text, success: success, fail: fail)
        
        Answers.logSearch(withQuery: text, customAttributes: nil)
    }
    
    func cancel() {
        dataTask?.cancel()
        news.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
