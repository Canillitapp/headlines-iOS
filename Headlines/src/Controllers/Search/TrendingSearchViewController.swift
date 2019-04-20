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

        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            tableView.contentOffset = CGPoint(
                x: 0,
                y: -refreshControl!.frame.size.height
            )
            refreshControl?.beginRefreshing()
        }

        fetchTrending()
    }

    private func fetchTrending() {
        service.fetchTrendingTerms(success: { [unowned self] in
            self.terms = $0
            if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
                self.refreshControl?.endRefreshing()
            }
            }, fail: { [unowned self] _ in
                if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
                    self.refreshControl?.endRefreshing()
                }
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
        let term = terms[indexPath.row].criteria
        didSelect(terms[indexPath.row].criteria)

        // Save "Siri suggestion" to search news for <Topic>
        if #available(iOS 12.0, *) {
            let activity = SuggestionsHelper.searchActivity(from: term)
            self.userActivity = activity
        }
    }

    @IBAction func reload(_ sender: UIRefreshControl) {
        fetchTrending()
    }

    func set(enabled: Bool) {
        let textColor = enabled ?
        UIColor(red: 246/255, green: 35/255, blue: 84/255, alpha: 1.0) :
        UIColor.darkGray
        guard let cells = tableView.visibleCells as? [TrendingSearchTermTableViewCell] else {
            return
        }
        cells.forEach { $0.label.textColor = textColor }
    }
}
