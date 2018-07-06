//
//  Searchable.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

protocol Searchable {
    func search(text: String?)
    func cancel()
}

class AutoSearchResultUpdater: NSObject, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchable = searchController.searchResultsController as? Searchable else {
            fatalError("The searchResultsController is does not conform to Searchable.")
        }
        searchable.search(text: searchController.searchBar.text)
    }
}
