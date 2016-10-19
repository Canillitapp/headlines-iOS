//
//  News.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/24/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SwiftyJSON

class News: NSObject {
    
    var title: String?
    var url: NSURL?
    var date: Date?
    var source: String?
    
    init(json: JSON) {
        title = json["title"].string
        url = json["url"].URL as NSURL?
        
        let timestamp = json["date"].doubleValue
        date = Date(timeIntervalSince1970: timestamp)
        
        source = json["source_name"].string
        super.init()
    }
}
