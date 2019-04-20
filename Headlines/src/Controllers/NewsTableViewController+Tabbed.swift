//
//  NewsTableViewController+Tabbed.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 19/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TabbedViewController
extension NewsTableViewController: TabbedViewController {

    func tabbedViewControllerWasDoubleTapped() {
        guard let tableView = tableView else {
            return
        }

        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
}
