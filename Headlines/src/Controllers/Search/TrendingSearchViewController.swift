//
//  TrendingSearchViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class TrendingSearchViewController: UITableViewController {
    
    private var terms = [TrendingTerm]() {
        didSet {
            tableView.reloadData()
        }
    }
    let service = NewsService()
    var didSelect: (String) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentOffset = CGPoint(
            x:0,
            y: -refreshControl!.frame.size.height
        )
        refreshControl?.beginRefreshing()
        fetchTrending()
    }
    
    private func fetchTrending() {
        service.fetchTrendingTerms(success: { [unowned self] in
            self.terms = $0
            self.refreshControl?.endRefreshing()
            }, fail: { _ in
                self.refreshControl?.endRefreshing()
        })
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "trending_term_cell"
            ) as! TrendingSearchTermTableViewCell
        cell.label.text = terms[indexPath.row].criteria
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(terms[indexPath.row].criteria)
    }
    
    @IBAction func reload(_ sender: UIRefreshControl) {
        fetchTrending()
    }
}
