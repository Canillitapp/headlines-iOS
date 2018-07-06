//
//  TrendingSearchViewController.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class TrendingSearchViewController: SearchViewController<TrendingSearchTermTableViewCell, NewsSearchViewController> {
    
    private let elements = ["macri", "messi", "mundial", "cristina", "mbappé", "fmi"]
    
    init() {
        let storboard = UIStoryboard(name: "Trending", bundle: Bundle.main)
        let resultController = storboard.instantiateViewController(
            withIdentifier: "NewsSearchViewController"
            ) as! NewsSearchViewController
        super.init(resultController: resultController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar"
        let headerView = TrendingSearchTableHeaderView(
            frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        )
        headerView.set(title: "Trending")
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
        cell.textLabel?.text = elements[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        beginSearch(text: elements[indexPath.row])
    }
}
