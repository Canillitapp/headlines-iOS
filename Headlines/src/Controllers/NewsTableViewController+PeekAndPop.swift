//
//  NewsTableViewController+PeekAndPop.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension NewsTableViewController {

    func setupPreview() {
        guard let tableView = tableView else {
            return
        }

        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(self.handleLongPress)
        )

        longPressRecognizer.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPressRecognizer)
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
