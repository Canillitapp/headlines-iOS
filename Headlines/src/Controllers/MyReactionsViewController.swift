//
//  MyReactionsViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/25/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SafariServices

class MyReactionsViewController: UITableViewController {
    let reactionsService = ReactionsService()
    var reactions = [Reaction]()
    
    //  MARK: Private
    func fetchMyReactions() {
        refreshControl?.beginRefreshing()
        
        let success: (URLResponse?, [Reaction]) -> () = { response, reactions in
            self.refreshControl?.endRefreshing()
            
            self.reactions.removeAll()
            self.reactions.append(contentsOf: reactions)
            self.tableView.reloadData()
        }
        
        let fail: (Error) -> () = { error in
            self.refreshControl?.endRefreshing()
            
            print(error.localizedDescription)
        }
        
        reactionsService.getReactions(success: success, fail: fail)
    }
    
    //  MARK: Public
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Setup refresh control
        let refreshCtrl = UIRefreshControl()
        tableView.refreshControl = refreshCtrl
        
        refreshCtrl.tintColor = UIColor(red:0.99, green:0.29, blue:0.39, alpha:1.00)
        refreshCtrl.addTarget(self, action: #selector(fetchMyReactions), for: .valueChanged)
        
        //  Had to set content offset because of UIRefreshControl bug
        //  http://stackoverflow.com/a/31224299/994129
        tableView.contentOffset = CGPoint(x:0, y:-refreshCtrl.frame.size.height)
        
        fetchMyReactions()
    }
    
    //  MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? ReactionTableViewCell else {
                return UITableViewCell()
        }
        
        let r = reactions[indexPath.row]
        guard let n = r.news else {
            return cell
        }
        
        cell.emojiLabel.text = r.reaction
        cell.reactionLabel.text = n.title
        cell.reactionImageView.sd_setImage(with: n.imageUrl)
        
        return cell
    }
    
    //  MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let r = reactions[indexPath.row]
        
        guard let n = r.news else {
            return
        }
        
        if let url = n.url {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true, completion: nil)
        }
    }
}
