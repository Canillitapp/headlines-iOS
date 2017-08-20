//
//  NewsTableViewControllerDataSource.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/22/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

protocol NewsTableViewControllerDataSource {
    var shouldDisplayPullToRefreshControl: Bool { get }
    func fetchNews(success: ((_: [News]) -> Void)?, fail: ((_ error: NSError) -> Void)?)
}
