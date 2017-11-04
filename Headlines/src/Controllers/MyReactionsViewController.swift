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
import Crashlytics
import ViewAnimator

class MyReactionsViewController: UITableViewController {
    let reactionsService = ReactionsService()
    var reactions = [Reaction]()
    
    // MARK: Private
    func openURL(_ url: URL) {
        guard let shouldOpenNewsInsideApp = UserDefaults.standard.object(forKey: "open_news_inside_app") as? Bool else {
            //  By default, open the news using Safari outside the app
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
        
        if shouldOpenNewsInsideApp {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func endRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func startRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            refreshControl?.beginRefreshing()
            self.tableView?.prepareViews()
        }
    }
    
    func showControllerWithError(_ error: NSError) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Sorry",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchMyReactions() {
        self.startRefreshing()
        
        let success: (URLResponse?, [Reaction]) -> Void = { [unowned self] response, reactions in
            self.endRefreshing()
            
            self.reactions.removeAll()
            self.reactions.append(contentsOf: reactions)
            self.tableView.reloadData()
            
            if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
                let animation = AnimationType.from(direction: .right, offset: 10.0)
                self.tableView?.animateViews(
                    animations: [animation],
                    initialAlpha: 0.0,
                    finalAlpha: 1.0,
                    delay: 0.0,
                    duration: 0.3,
                    animationInterval: 0.1,
                    completion: nil
                )
            }
        }
        
        let fail: (Error) -> Void = { [unowned self] error in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.endRefreshing()
            }
            self.showControllerWithError(error as NSError)
        }
        
        reactionsService.getReactions(success: success, fail: fail)
    }
    
    // MARK: Public
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Answers.logCustomEvent(withName: "my_reactions_appear", customAttributes: nil)
    }
    
    // MARK: UITableViewDataSource
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
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let r = reactions[indexPath.row]
        
        guard let n = r.news else {
            return
        }
        
        if let url = n.url {
            openURL(url)
        }
    }
}
