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
        resultController.didSelectSuggestion = search
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
        searchController.delegate = self
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
        searchController.searchBar.resignFirstResponder()
        navigationController?.navigationBarShadow(hidden: false)
        if let term = term {
            resultController.fetch(term: term)

            // Save "Siri suggestion" to search news for <Topic>
            if #available(iOS 12.0, *) {
                let activity = SuggestionsHelper.searchActivity(from: term)
                self.userActivity = activity
            }
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        trendingSearchController.set(enabled: false)
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        trendingSearchController.set(enabled: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.navigationBarShadow(hidden: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(term: searchBar.text)
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
