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
    var identifier: String
    var title: String?
    var url: URL
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
    
    class func decodeArrayOfNews(from data: Data) -> [News] {
        // Decoding Data into News
        // (replace this with Decodable snippet in the future)
        let json = try? JSON(data: data)
        
        var news = [News]()
        for (_, v) in json! {
            if let n = News(json: v) {
                news.append(n)
            }
        }
        return news
    }

    
    init(identifier: String, url: URL) {
        self.identifier = identifier
        self.url = url
        super.init()
    }
    
    init?(json: JSON) {
        
        // identifier is mandatory
        guard let newsId = json["news_id"].int else {
            return nil
        }
        identifier = "\(newsId)"
        
        // title is mandatory
        guard let newsTitle = json["title"].string else {
            return nil
        }
        title = newsTitle
        
        // url is mandatory
        guard let url = json["url"].url else {
            return nil
        }
        self.url = url
        
        // date is mandatory
        guard let timestamp = json["date"].double else {
            return nil
        }
        date = Date(timeIntervalSince1970: timestamp)
        
        // source
        source = json["source_name"].string
        
        // category
        category = json["category"].string
        
        // imageURL
        if let imgURLString = json["img_url"].string {
            imageUrl = Parser.url(from: imgURLString)
        }
        
        // reactions
        var tmp: [Reaction] = []
        
        json["reactions"].forEach ({ (_, j) in
            let r = Reaction(json: j)
            tmp.append(r)
        })
        
        reactions = tmp
        
        super.init()
    }
}
