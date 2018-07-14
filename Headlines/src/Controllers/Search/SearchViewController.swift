//
//  SearchViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/27/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    fileprivate var searchController: UISearchController!
    private var trendingSearchController: TrendingSearchViewController!
    private let resultController = NewsSearchStateController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUISearchController()
        navigationController?.navigationBarShadow(hidden: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let trendingSearchController = destination as? TrendingSearchViewController {
            trendingSearchController.didSelect = search
            self.trendingSearchController = trendingSearchController
        }
    }
    
    // MARK: - Search
    private func configureUISearchController() {
        searchController = UISearchController(
            searchResultsController: resultController
        )
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Buscar"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor(
            red: 246/255, green: 35/255, blue: 84/255, alpha: 1.0
        )
        definesPresentationContext = true
        searchController.searchResultsUpdater = resultController
        navigationItem.titleView = searchController.searchBar
    }
    
    func search(term: String?) {
        searchController.isActive = true
        searchController.searchBar.text = term
        navigationController?.navigationBarShadow(hidden: false)
        if let term = term {
            resultController.fetch(term: term)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.navigationBarShadow(hidden: true)
    }
}

extension SearchViewController: TabbedViewController {
    
    func tabbedViewControllerWasDoubleTapped() {
        guard
            let searchStateController = searchController.searchResultsController as? NewsSearchStateController,
            let vc = searchStateController.stateViewController.shownViewController as? NewsSearchViewController else {
                return
        }
        vc.tabbedViewControllerWasDoubleTapped()
    }
}

extension UINavigationController {
    func navigationBarShadow(hidden: Bool) {
        navigationBar.setValue(hidden, forKey: "hidesShadow")
    }
}
