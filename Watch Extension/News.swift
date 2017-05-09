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
    var identifier: String?
    var title: String?
    var url: URL?
    var date: Date?
    var source: String?
    var imageUrl: URL?
    var reactions: [Reaction]?
    
    init(json: JSON) {
        
        if let news_id = json["news_id"].int {
            identifier = "\(news_id)"
        }
        
        title = json["title"].string
        url = json["url"].URL
        
        let timestamp = json["date"].doubleValue
        date = Date(timeIntervalSince1970: timestamp)
        
        source = json["source_name"].string
        
        imageUrl = json["img_url"].URL
        
        var tmp: [Reaction] = []
        
        json["reactions"].forEach ({ (_, j) in
            let r = Reaction(json: j)
            tmp.append(r)
        })
        
        reactions = tmp
        
        super.init()
    }
}
