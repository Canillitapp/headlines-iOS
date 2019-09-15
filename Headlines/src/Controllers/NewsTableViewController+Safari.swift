//
//  NewsTableViewController+Safari.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SafariServices

// MARK: - Safari Related
extension NewsTableViewController {

    private func trackOpenNews(_ news: News) {
        guard let contextFrom = trackContextFrom else {
            return
        }

        contentViewsService.postContentView(news.identifier, context: contextFrom, handler: nil)
    }

    func openNews(_ news: News) {

        trackOpenNews(news)

        if userSettingsManager.shouldOpenNewsInsideApp {
            let vc = SFSafariViewController(url: news.url, entersReaderIfAvailable: true)
            vc.delegate = self
            self.selectedNews = news
            present(vc, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(news.url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - SFSafariViewControllerDelegate
extension NewsTableViewController: SFSafariViewControllerDelegate {

    func safariViewController(_ controller: SFSafariViewController,
                              activityItemsFor URL: URL,
                              title: String?) -> [UIActivity] {

        guard let n = self.selectedNews else {
            return []
        }

        let activity = ShareCanillitapActivity(withNews: n)
        return [activity]
    }
}
