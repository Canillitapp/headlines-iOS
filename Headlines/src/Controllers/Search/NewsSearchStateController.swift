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
    
    lazy var stateViewController = ContentStateViewController()
    
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
        let terms = [
            "Macri",
            "Cristina",
            "Messi",
            "Mundial",
            "Cafe",
            "Lab",
            "Canillita"
        ]
        render(terms: terms.filter { $0.hasPrefix(text) })
    }
    
    private func cancel() {
        dataTask?.cancel()
    }
    
    private func render(news: [News]?) {
        let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
        let newsController = storyboard.instantiateViewController(
            withIdentifier: "NewsSearchViewController"
            ) as! NewsSearchViewController
        newsController.show(news: news)
        stateViewController.transition(to: .render(newsController))
    }
    
    private func render(terms: [String]) {
        let tableController = TableViewController()
        tableController.terms = terms
        tableController.didSelect = fetch
        stateViewController.transition(to: .render(tableController))
    }
    
    func fetch(term: String) {
        cancel()
        stateViewController.transition(to: .loading)
        Answers.logSearch(withQuery: term, customAttributes: nil)
        self.dataTask = self.service.searchNews(
            term,
            success: self.render,
            fail: self.error
        )
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
    }
}

class TableViewController: UITableViewController {
    var terms = [String]()
    var didSelect: (String) -> Void = { _ in }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = terms[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(terms[indexPath.row])
    }
}
