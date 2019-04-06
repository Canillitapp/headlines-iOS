//
//  News.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/24/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation

class News: NSObject, Decodable {
    // Required
    var identifier: String
    var date: Date
    var title: String
    var url: URL

    // Optional
    var source: String?
    var category: String?
    var imageUrl: URL?
    var reactions: [Reaction]?

    enum CodingKeys: String, CodingKey {
        case identifier = "news_id"
        case title
        case url
        case date
        case source = "source_name"
        case category
        case imageUrl = "img_url"
        case reactions
    }
    
    var representativeReaction: Reaction? {
        guard let r = reactions?.sorted(by: { (reactionA, reactionB) -> Bool in
            return reactionA.amount > reactionB.amount
        }) else {
            return nil
        }
        
        return r.first
    }
    
    class func decodeArrayOfNews(from data: Data) throws -> [News] {
        let throwables = try JSONDecoder().decode([Throwable<News>].self, from: data)
        return throwables.compactMap { $0.value }
    }
    
    init(identifier: String, url: URL, title: String, date: Date) {
        self.identifier = identifier
        self.url = url
        self.date = date
        self.title = title
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Required: Identifier
        guard let newsId = try? values.decode(Int.self, forKey: .identifier) else {
            throw NSError(
                domain: "News",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid identifier"]
            )
        }
        identifier = "\(newsId)"

        // Required: Date
        guard let timestamp = try? values.decode(TimeInterval.self, forKey: .date) else {
            throw NSError(
                domain: "News",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid date"]
            )
        }
        date = Date(timeIntervalSince1970: timestamp)

        // Required: URL
        do {
            url = try values.decode(URL.self, forKey: .url)
        } catch {
            if let urlString = try values.decodeIfPresent(String.self, forKey: .url) {
                print("ERROR: Tried to parse URL: \(urlString)")
            }
            throw error
        }

        // Required: Title
        title = try values.decode(String.self, forKey: .title)

        //  Optional values
        //  The reason of "try?" instead of "try" is because these fields are optional
        source = try? values.decode(String.self, forKey: .source)
        category = try? values.decode(String.self, forKey: .category)
        imageUrl = try? values.decode(URL.self, forKey: .imageUrl)
        reactions = try? values.decode([Reaction].self, forKey: .reactions)
    }
}
