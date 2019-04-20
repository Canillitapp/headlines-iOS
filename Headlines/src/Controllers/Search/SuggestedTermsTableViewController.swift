//
//  SuggestedTermsTableViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 14/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class SuggestedTermsTableViewController: UITableViewController {

    var searchedTerm = String()
    var tags = [Tag]()
    var didSelect: (String) -> Void = { _ in }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SuggestedTermTableViewCell
        cell.set(tag: tags[indexPath.row], searchedTerm: searchedTerm)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(tags[indexPath.row].name)
    }
}
