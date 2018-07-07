//
//  SearchViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/27/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class SearchViewController<Cell: UITableViewCell, T: UIViewController & Searchable>: UITableViewController,
UISearchBarDelegate, UISearchControllerDelegate {
    
    // Config
    public enum Mode {
        case automatic
        case manual
    }
    
    // MARK: - Properties
    private let resultController: T
    private let searchController: UISearchController
    private let mode: Mode
    private var searchResultUpdater: AutoSearchResultUpdater?
    
    var reuseIdentifier: String {
        return String(describing: Cell.self)
    }

    // MARK: - Init & Deinit
    public init(resultController: T, searchMode: Mode = .manual) {
        self.resultController = resultController
        searchController = UISearchController(
            searchResultsController: resultController
        )
        self.mode = searchMode
        super.init(style: .plain)
        configureUISearchController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        let nibName = String(describing: Cell.self).components(separatedBy: ".").last!
        if Bundle.main.path(forResource: nibName, ofType: "nib") != nil {
            let nib = UINib(nibName: nibName, bundle: Bundle(for: Cell.self))
            tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        } else {
            tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        }
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = true
        searchController.view.isHidden = false
    }
    
    func beginSearch(text: String) {
        searchController.searchBar.text = text
        resultController.search(text: text)
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Search
    private func configureUISearchController() {
        searchController.searchBar.placeholder = "Buscar"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barStyle = .blackOpaque
        definesPresentationContext = true
        switch mode {
        case .automatic:
            searchResultUpdater = AutoSearchResultUpdater()
            searchController.searchResultsUpdater = searchResultUpdater
        case .manual:
            searchController.delegate = self
            searchController.searchBar.delegate = self
        }
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.view.isHidden = false
        resultController.cancel()
        resultController.search(text: searchBar.text)
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchController.view.isHidden = true
        }
    }
    
    // MARK: - UISearchControllerDelegate
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.view.isHidden = true
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.view.isHidden = true
        resultController.cancel()
    }
}
