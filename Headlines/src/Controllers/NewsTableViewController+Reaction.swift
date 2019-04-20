//
//  NewsTableViewController+Reaction.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

extension NewsTableViewController {

    func prepareReaction(with segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? ReactionPickerViewController,
            let newsViewModel = sender as? NewsCellViewModel else {
                return
        }

        vc.news = newsViewModel.news
        nav.modalPresentationStyle = .formSheet
    }

    func addReaction(_ currentReaction: String, toNews currentNews: News) {
        guard let n = filteredNewsViewModels.filter ({$0.news.identifier == currentNews.identifier}).first else {
            return
        }

        n.news.reactions = currentNews.reactions?.sorted(by: { $0.date < $1.date })

        if let i = filteredNewsViewModels.index(of: n) {

            guard let tableView = tableView else {
                return
            }

            let indexPathToReload = IndexPath(row: i, section: 0)
            tableView.reloadRows(at: [indexPathToReload], with: .none)
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

        let success: (URLResponse?, News?) -> Void = { [unowned self] (_, updatedNews) in
            guard let n = updatedNews else {
                return
            }
            self.addReaction(selectedReaction, toNews: n)
        }

        let fail: (Error) -> Void = { [weak self] err in

            let error = err as NSError

            if let s = self {
                s.showControllerWithError(error)
            }
        }

        reactionsService.postReaction(
            selectedReaction,
            atPost: currentNews.identifier,
            success: success,
            fail: fail
        )
    }
}

// MARK: - NewsCellViewModelDelegate
extension NewsTableViewController: NewsCellViewModelDelegate {

    func newsViewModel(_ viewModel: NewsCellViewModel, didSelectReaction reaction: Reaction) {

        let success: (URLResponse?, News?) -> Void = { [unowned self] (response, updatedNews) in
            guard let n = updatedNews else {
                return
            }
            self.addReaction(reaction.reaction, toNews: n)
        }

        let fail: (Error) -> Void = { [unowned self] (err) in
            self.showControllerWithError(err as NSError)
        }

        reactionsService.postReaction(
            reaction.reaction,
            atPost: viewModel.news.identifier,
            success: success,
            fail: fail
        )
    }

    func newsViewModelDidSelectReactionPicker(_ viewModel: NewsCellViewModel) {
        performSegue(withIdentifier: "reaction", sender: viewModel)
    }
}
