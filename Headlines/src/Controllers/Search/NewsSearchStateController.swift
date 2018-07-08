//
//  NewsSearchStateController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import Crashlytics

class NewsSearchStateController: UIViewController, UISearchResultsUpdating {

    private let service = NewsService()
    private var dataTask: URLSessionDataTask?
    private let dispatchQueue = DispatchQueue.global(qos: .utility)
    private var dispatchWorkItem: DispatchWorkItem?
    private var previousTerm: String?
    
    private lazy var stateViewController = ContentStateViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        add(stateViewController)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            cancel()
            return
        }
        
        if text == previousTerm { return }
        previousTerm = text
        cancel()
        stateViewController.transition(to: .loading)
        dispatchWorkItem = DispatchWorkItem { [unowned self] in
            Answers.logSearch(withQuery: text, customAttributes: nil)
            self.dataTask = self.service.searchNews(
                text,
                success: self.render,
                fail: self.error
            )
        }
        
        if let dispatchWorkItem = dispatchWorkItem {
            dispatchQueue.asyncAfter(
                deadline: .now() + .milliseconds(500),
                execute: dispatchWorkItem
            )
        }
    }
    
    private func cancel() {
        dataTask?.cancel()
        dispatchWorkItem?.cancel()
    }
    
    private func render(news: [News]?) {
        let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
        let newsController = storyboard.instantiateViewController(
            withIdentifier: "NewsSearchViewController"
            ) as! NewsSearchViewController
        newsController.show(news: news)
        stateViewController.transition(to: .render(newsController))
    }
    
    private func error(_ error: NSError) {
        guard error.code == NSURLErrorCancelled else {
            let alert = UIAlertController(
                title: "Sorry",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // transition to error state.
    }
}
