//
//  NewsSearchStateController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class NewsSearchStateController: UIViewController, UISearchResultsUpdating {

    private let service = NewsService()
    private var dataTask: URLSessionDataTask?
    private let dispatchQueue = DispatchQueue.global(qos: .utility)
    private var dispatchWorkItem: DispatchWorkItem?
    private var previousTerm: String?

    var didSelectSuggestion: (String) -> Void = { _ in }
    lazy var stateViewController = ContentStateViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        add(stateViewController)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            dataTask?.cancel()
            return
        }

        if text == previousTerm { return }
        previousTerm = text
        dataTask?.cancel()
        if stateViewController.shownViewController is NewsSearchViewController {
            stateViewController.transition(to: .loading)
        }

        dataTask = service.fetchTags(tag: text, handler: { [weak self] result in
            switch result {
            case .success(let tags):
                self?.render(tags: tags, searchedTerm: text)
            case .failure:
                print("Fail at updateSearchResults")
            }
        })
    }

    private func render(searchTerm: String) {
        let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
        let newsController = storyboard.instantiateViewController(
            withIdentifier: "NewsSearchViewController"
            ) as! NewsSearchViewController
        newsController.newsDataSource = SearchNewsDataSource(searchTerm: searchTerm)

        /*
         * This is not ideal, adding a 0.1 delay so refreshIndicator
         * animates properly when tapping an existing "Trending Search Term".
         *
         * I need to make a decent refactor here and remove some of the intricate
         * logic that handles this.
         */
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.stateViewController.transition(to: .render(newsController))
        }
    }

    private func render(tags: [Tag], searchedTerm: String) {
        let storyboard = UIStoryboard(name: "Search", bundle: Bundle.main)
        let termsTableController = storyboard.instantiateViewController(
            withIdentifier: "SuggestedTermsTableViewController"
            ) as! SuggestedTermsTableViewController
        termsTableController.tags = tags
        termsTableController.searchedTerm = searchedTerm
        termsTableController.didSelect = didSelectSuggestion
        stateViewController.transition(to: .render(termsTableController))
    }

    func fetch(term: String) {
        dataTask?.cancel()
        render(searchTerm: term)
    }

    private func error(_ error: Error) {
        let alert = UIAlertController(
            title: "Sorry",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
