//
//  NewsManager.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 03/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

final class NewsManager {
    var topics: [Topic]?
    var categories: [Category]?

    static let sharedInstance = NewsManager()
    private init() {}
}
