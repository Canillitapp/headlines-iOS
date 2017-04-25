//
//  MyReactionsViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/25/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

class MyReactionsViewController: UITableViewController {
    let reactionsService = ReactionsService()
    var reactions = [Reaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let success: (URLResponse?, [Reaction]) -> () = { response, reactions in
            self.reactions.removeAll()
            self.reactions.append(contentsOf: reactions)
            self.tableView.reloadData()
        }
        
        let fail: (Error) -> () = { error in
            print(error.localizedDescription)
        }
        
        reactionsService.getReactions(success: success, fail: fail)
    }
    
    //  MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? NewsTableViewCell else {
                return UITableViewCell()
        }
        
        return cell
    }
}
