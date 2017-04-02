//
//  NewsTableViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 11/16/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices

class NewsTableViewController: UITableViewController, NewsCellViewModelDelegate {

    var news: [News] = [] {
        didSet {
            news.forEach({ (n) in
                let viewModel = NewsCellViewModel(news: n)
                viewModel.delegate = self
                newsViewModels.append(viewModel)
            })
        }
    }
    
    var newsViewModels: [NewsCellViewModel] = []

    //  MARK: Private
    
    func addReaction(_ currentReaction: String, toNews currentNews: News) {
        let n = news.filter ({$0 == currentNews}).first
        if n != nil {
            var reaction = n?.reactions?.filter({$0.reaction == currentReaction}).first
            if reaction != nil {
                reaction?.amount += 1
            } else {
                reaction = Reaction(reaction: currentReaction, amount: 1)
                n?.reactions?.append(reaction!)
            }
            
            if let i = news.index(of: currentNews) {
                let indexPathToReload = IndexPath(row: i, section: 0)
                tableView.reloadRows(at: [indexPathToReload], with: .none)
            }
        }
    }
    
    //  MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func unwindToNews(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? ReactionPickerViewController else {
            return
        }
        
        guard let currentNews = vc.news,
            let selectedReaction = vc.selectedReaction else {
            return
        }

        addReaction(selectedReaction, toNews: currentNews)
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //  MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = news[indexPath.row]
        if let url = n.url {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true, completion: nil)
        }
    }
    
    //  MARK: NewsCellViewModelDelegate
    
    func newsViewModel(_ viewModel: NewsCellViewModel, didSelectReaction reaction: Reaction) {
        addReaction(reaction.reaction, toNews: viewModel.news)
    }

    func newsViewModelDidSelectReactionPicker(_ viewModel: NewsCellViewModel) {
        performSegue(withIdentifier: "reaction", sender: viewModel)
    }
}
