//
//  NewsTableViewController+Safari.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SafariServices

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
