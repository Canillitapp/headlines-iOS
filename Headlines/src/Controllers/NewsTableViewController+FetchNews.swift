//
//  NewsTableViewController+FetchNews.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import ViewAnimator

extension NewsTableViewController {

    enum FetchMode {
        case reload
        case nextPage

        func shouldAnimatePullToRefresh() -> Bool {
            switch self {
            case .reload:
                return true
            default:
                return false
            }
        }

        func shouldAnimateCells() -> Bool {
            switch self {
            case .reload:
                return true
            default:
                return false
            }
        }
    }

    func setupPullToRefreshControl() {
        //  Setup refresh control
        guard let tableView = tableView else {
            return
        }

        let refreshCtrl = UIRefreshControl()
        tableView.refreshControl = refreshCtrl

        refreshCtrl.tintColor = UIColor(red: 0.99, green: 0.29, blue: 0.39, alpha: 1.00)
        refreshCtrl.addTarget(self, action: #selector(fetchReload), for: .valueChanged)

        //  Had to set content offset because of UIRefreshControl bug
        //  http://stackoverflow.com/a/31224299/994129
        tableView.contentOffset = CGPoint(x: 0, y: -refreshCtrl.frame.size.height)
    }

    @objc func fetchReload() {
        fetch(mode: .reload)
    }

    func updateNews(_ news: [News], _ mode: FetchMode) {

        guard let tableView = tableView else {
            return
        }

        // Stop pull to refresh animation (if needed)
        if mode.shouldAnimatePullToRefresh() {
            endRefreshing()
        }

        // If news are == 0, then we reached to the end
        guard news.count > 0 else {
            canFetchMoreNews = false
            return
        }

        // Generate NewsCellViewModels from News
        let viewModels = self.viewModels(from: news)

        // Calculate indexpaths to update
        let filteredNews = filterNews(viewModels)

        let indexPaths = indexPathsToUpdate(
            start: newsViewModels.count,
            length: filteredNews.count
        )

        // Append all news to newsViewModels
        newsViewModels.append(contentsOf: viewModels)

        // Append filtered news and update our tableView
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            filteredNewsViewModels.append(contentsOf: filteredNews)
            tableView.insertRows(at: indexPaths, with: .none)
            tableView.setContentOffset(tableView.contentOffset, animated: false)
            tableView.endUpdates()
        }

        // Animate all cells appearing (if needed)
        if mode.shouldAnimateCells() {
            UIView.animate(
                views: tableView.visibleCells,
                animations: [AnimationType.from(direction: .right, offset: 10.0)],
                animationInterval: 0.1
            )
        }

        lastPage += 1
        isFetchingNews = false
    }

    func fetch(mode: FetchMode) {

        guard let newsDataSource = newsDataSource,
            let tableView = tableView else {

                return
        }

        isFetchingNews = true

        // Animate pull to refresh (if needed)
        if mode.shouldAnimatePullToRefresh() {
            startRefreshing()
        }

        let fail: ((NSError?) -> Void) = { [weak self] _ in

            guard let strongSelf = self else {
                return
            }

            // Stop pull to refresh animation (if needed)
            if mode.shouldAnimatePullToRefresh() {
                strongSelf.endRefreshing()
            }

            strongSelf.isFetchingNews = false
        }

        switch mode {
        case .reload:
            lastPage = 1
            newsViewModels.removeAll()
            filteredNewsViewModels.removeAll()
            tableView.reloadData()

        default:
            break
        }

        let handler: ((Result <[News], Error>) -> Void) = { [weak self] result in
            switch result {
            case .success(let news):
                self?.updateNews(news, mode)

            case .failure:
                // Stop pull to refresh animation (if needed)
                if mode.shouldAnimatePullToRefresh() {
                    self?.endRefreshing()
                }

                self?.isFetchingNews = false
            }
        }
        newsDataSource.fetchNews(page: lastPage, handler: handler)
    }
}

private extension NewsTableViewController {

    func filterNews(_ news: [NewsCellViewModel]) -> [NewsCellViewModel] {

        guard
            let dataSource = newsDataSource,
            let whitelist = userSettingsManager.whitelistedSources,
            dataSource.isFilterEnabled == true,
            whitelist.count > 0 else {

                return news
        }

        return news.filter { whitelist.contains($0.source!) }
    }

    func startRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            tableView?.refreshControl?.beginRefreshing()
        }
    }

    func endRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            tableView?.refreshControl?.endRefreshing()
        }
    }

    func viewModels(from news: [News]) -> [NewsCellViewModel] {
        return news.map({ [weak self] n -> NewsCellViewModel in
            let viewModel = NewsCellViewModel(news: n)
            viewModel.delegate = self
            viewModel.dateStyle = self?.preferredDateStyle
            return viewModel
        })
    }

    func indexPathsToUpdate(start: Int, length: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        let end = start + length - 1

        for index in start...end {
            indexPaths.append(IndexPath(row: index, section: 0))
        }

        return indexPaths
    }
}
