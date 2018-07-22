//
//  News.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/24/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation

class News: NSObject, Decodable {
    var newsId: Int?
    var title: String?
    var url: URL?
    var date: Date?
    var source: String?
    var category: String?
    var imageUrl: URL?
    var reactions: [Reaction]?
    
    var identifier: String? {
        guard let newsId = newsId else {
            return nil
        }
        return "\(newsId)"
    }

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

    // MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case newsId = "news_id"
        case title
        case url
        case date
        case source = "source_name"
        case category
        case imageUrl = "img_url"
        case reactions
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        newsId = try container.decode(Int.self, forKey: .newsId)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(URL.self, forKey: .url)
        let decodedDate = try container.decode(Int.self, forKey: .date)
        date = Date(timeIntervalSince1970: TimeInterval(decodedDate))
        source = try container.decodeIfPresent(String.self, forKey: .source)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
        reactions = try container.decodeIfPresent([Reaction].self, forKey: .reactions)
    }
}
