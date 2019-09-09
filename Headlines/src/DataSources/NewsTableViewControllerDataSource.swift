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
    var isFilterEnabled: Bool { get }
    var isPaginationEnabled: Bool { get }
    func fetchNews(page: Int, handler: ((_ result: Result <[News], Error>) -> Void)?)
}
