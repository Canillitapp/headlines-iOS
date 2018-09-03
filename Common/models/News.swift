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
    var category: String?
    var imageUrl: URL?
    var reactions: [Reaction]?
    
    var representativeReaction: Reaction? {
        guard let r = reactions?.sorted(by: { (reactionA, reactionB) -> Bool in
            return reactionA.amount > reactionB.amount
        }) else {
            return nil
        }
        
        return r.first
    }
    
    override init() {
        super.init()
    }
    
    init?(json: JSON) {
        
        guard let newsId = json["news_id"].int else {
            return nil
        }
        identifier = "\(newsId)"
        
        guard let newsTitle = json["title"].string else {
            return nil
        }
        title = newsTitle
        
        if let urlString = json["url"].string {
            url = Parser.url(from: urlString)
        }
        
        guard let timestamp = json["date"].double else {
            return nil
        }
        date = Date(timeIntervalSince1970: timestamp)
        
        source = json["source_name"].string
        
        category = json["category"].string
        
        if let imgURLString = json["img_url"].string {
            imageUrl = Parser.url(from: imgURLString)
        }
        
        var tmp: [Reaction] = []
        
        json["reactions"].forEach ({ (_, j) in
            let r = Reaction(json: j)
            tmp.append(r)
        })
        
        reactions = tmp
        
        super.init()
    }
}
