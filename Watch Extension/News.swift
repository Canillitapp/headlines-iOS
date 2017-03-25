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
    var url: URL?
    var date: Date?
    var source: String?
    var imageUrl: URL?
    var reactions: [Reaction]?
    
    init(json: JSON) {
        title = json["title"].string
        url = json["url"].URL
        
        let timestamp = json["date"].doubleValue
        date = Date(timeIntervalSince1970: timestamp)
        
        source = json["source_name"].string
        
        imageUrl = json["img_url"].URL
        
        reactions = []
        for _ in 1...5 {
            let r = Reaction.randomReaction()
            reactions?.append(r)
        }
        
        super.init()
    }
}
