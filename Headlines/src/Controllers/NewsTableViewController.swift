//
//  NewsTableViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices

class NewsTableViewController: UITableViewController, NewsCellViewModelDelegate {

    var news: [News] = [] {
        didSet {
            newsViewModels.removeAll()
            news.forEach({ (n) in
                let viewModel = NewsCellViewModel(news: n)
                viewModel.delegate = self
                newsViewModels.append(viewModel)
            })
        }
    }
    
    let reactionsService = ReactionsService()
    var newsViewModels: [NewsCellViewModel] = []
    
    // MARK: Private
    func addReaction(_ currentReaction: String, toNews currentNews: News) {
        guard let n = news.filter ({$0.identifier == currentNews.identifier}).first else {
            return
        }
        
        n.reactions = currentNews.reactions
        
        if let i = news.index(of: n) {
            let indexPathToReload = IndexPath(row: i, section: 0)
            tableView.reloadRows(at: [indexPathToReload], with: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "reaction":
            guard let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? ReactionPickerViewController,
                let newsViewModel = sender as? NewsCellViewModel else {
                    return
            }
            
            vc.news = newsViewModel.news
            break
            
        default:
            return
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        
        if gesture.state != .began {
            return
        }
        
        let p = gesture.location(in: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: p) else {
            return
        }
        
        let viewModel = newsViewModels[indexPath.row]
        performSegue(withIdentifier: "reaction", sender: viewModel)

    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressRecognizer.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @IBAction func unwindToNews(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? ReactionPickerViewController else {
            return
        }
        
        guard let currentNews = vc.news,
            let selectedReaction = vc.selectedReaction else {
                return
        }
        
        reactionsService.postReaction(selectedReaction,
                                      atNews: currentNews,
                                      success: { (_, updatedNews) in
                                        guard let n = updatedNews else {
                                            return
                                        }
                                        self.addReaction(selectedReaction, toNews: n)
        }) { (err) in
            print("#ERROR \(err.localizedDescription)")
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? NewsTableViewCell else {
                return UITableViewCell()
        }
        
        let viewModel = newsViewModels[indexPath.row]
        
        cell.titleLabel.text = viewModel.title
        cell.sourceLabel.text = viewModel.source
        cell.timeLabel.text = viewModel.timeString
        cell.reactionsDataSource = viewModel
        cell.reactionsDelegate = viewModel
        
        if let imgURL = viewModel.imageURL {
            cell.newsImageView.isHidden = false
            cell.newsImageView.sd_setImage(with: imgURL, completed: nil)
        } else {
            cell.newsImageView.isHidden = true
        }
        
        cell.reactionsCollectionView.isHidden = !viewModel.shouldShowReactions
        cell.reactionsHeightConstraint.constant = cell.reactionsCollectionView.isHidden ? 0 : 30
        cell.reactionsCollectionView.reloadData()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = news[indexPath.row]
        if let url = n.url {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: NewsCellViewModelDelegate
    
    func newsViewModel(_ viewModel: NewsCellViewModel, didSelectReaction reaction: Reaction) {
        reactionsService.postReaction(reaction.reaction,
                                      atNews: viewModel.news,
                                      success: { (_, updatedNews) in
                                        guard let n = updatedNews else {
                                            return
                                        }
                                        self.addReaction(reaction.reaction, toNews: n)
        }) { (err) in
            print("#ERROR \(err.localizedDescription)")
        }
    }
    
    func newsViewModelDidSelectReactionPicker(_ viewModel: NewsCellViewModel) {
        performSegue(withIdentifier: "reaction", sender: viewModel)
    }
}
