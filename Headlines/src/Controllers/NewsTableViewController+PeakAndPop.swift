//
//  NewsTableViewController+PeakAndPop.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

// MARK: - UIViewControllerPreviewingDelegate
extension NewsTableViewController: UIViewControllerPreviewingDelegate {

    private func setupPreview() {
        guard let tableView = tableView, hasRegisteredPreview == false else {
            return
        }

        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        } else {
            let longPressRecognizer = UILongPressGestureRecognizer(
                target: self,
                action: #selector(self.handleLongPress)
            )

            longPressRecognizer.delaysTouchesBegan = true
            tableView.addGestureRecognizer(longPressRecognizer)
        }

        hasRegisteredPreview = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupPreview()
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {

        guard let tableView = tableView else {
            return nil
        }

        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }

        let news = filteredNewsViewModels[indexPath.row].news

        let storyboard = UIStoryboard(name: "NewsPreview", bundle: nil)
        let vc: NewsPreviewViewController? = storyboard.instantiateInitialViewController() as? NewsPreviewViewController
        vc?.news = news
        vc?.newsViewController = self
        vc?.preferredContentSize = CGSize(width: 300, height: 300)
        selectedNews = news
        return vc
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {

        guard let url = selectedNews?.url else {
            return
        }

        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {

        if gesture.state != .began {
            return
        }

        let p = gesture.location(in: tableView)

        guard let tableView = tableView else {
            return
        }

        guard let indexPath = tableView.indexPathForRow(at: p) else {
            return
        }

        let viewModel = filteredNewsViewModels[indexPath.row]

        let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        vc.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)

        let shareAction = UIAlertAction(title: "Compartir Noticia", style: .default) { (_) in
            UIPasteboard.general.string = ShareCanillitapActivity.canillitappURL(fromNews: viewModel.news)
            vc.dismiss(animated: true, completion: nil)
        }
        vc.addAction(shareAction)

        let reactAction = UIAlertAction(title: "Agregar Reacción", style: .default) { [weak self] (_) in
            vc.dismiss(animated: false, completion: nil)
            self?.performSegue(withIdentifier: "reaction", sender: viewModel)
        }
        vc.addAction(reactAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            vc.dismiss(animated: true, completion: nil)
        }
        vc.addAction(cancelAction)

        present(vc, animated: true, completion: nil)
    }
}
