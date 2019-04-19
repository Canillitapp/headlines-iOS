//
//  NewsTableViewController+Filter.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

extension NewsTableViewController {

    func prepareFilter(with segue: UIStoryboardSegue) {
        guard let vc = segue.destination as? FilterViewController else {
            return
        }

        let sources = FilterSourcesDataSource.sources(fromNews: news)
        let selectedSources = FilterSourcesDataSource.preSelectedSources(fromNewsViewModels: filteredNewsViewModels)
        vc.filterSourcesDataSource = FilterSourcesDataSource(sources: sources, preSelectedSources: selectedSources)

        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .overFullScreen
    }

    @objc func filterButtonTapped() {
        performSegue(withIdentifier: "filter", sender: self)
    }

    func setupFilterButtonItem() {
        let filterImage = UIImage(named: "filter_icon")
        let filterButtonItem = UIBarButtonItem(
            image: filterImage,
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        filterButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = filterButtonItem
    }

    @IBAction func unwindFromFilter(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? FilterViewController else {
            return
        }

        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {

        case "dismiss":
            return

        case "sourcesApply":
            guard let dataSource = vc.filterSourcesDataSource else {
                return
            }

            userSettingsManager.whitelistedSources = dataSource.selectedSources

            filteredNewsViewModels = newsViewModels.filter { dataSource.selectedSources.contains($0.source!) }

            guard let tableView = tableView else {
                return
            }

            UIView.transition(
                with: tableView,
                duration: 0.30,
                options: .transitionCrossDissolve,
                animations: { tableView.reloadData() },
                completion: nil
            )
            return

        default:
            return
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension NewsTableViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DimPresentAnimationController()
        animator.isPresenting = true
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DimPresentAnimationController()
    }
}
