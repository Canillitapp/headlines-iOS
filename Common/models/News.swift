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
        guard let r = reactions?.sorted(by: { reactionA, reactionB -> Bool in
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
        identifier = "\(try values.decode(Int.self, forKey: .identifier))"

        // Required: Date
        let timestamp = try values.decode(TimeInterval.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestamp)

        // Required: URL
        do {
            url = try values.decode(URL.self, forKey: .url)
        } catch {

            // Trying to "sanitze" wrong formatted URL
            guard let urlString = try? values.decode(String.self, forKey: .url) else {
                // Something went really wrong (nil URL maybe?)
                print("ERROR: Tried to parse URL at news: \(identifier)")
                throw error
            }

            let specialCharacters = CharacterSet(charactersIn: "áéíóúñÁÉÍÓÚÑ").inverted

            guard
                let escapedURLString = urlString.addingPercentEncoding(withAllowedCharacters: specialCharacters),
                let escapedURL = URL(string: escapedURLString) else {

                    print("ERROR: Tried to parse URL: \(urlString)")
                    throw error
                }

            print("WARNING: URL was wrong formatted: \(urlString). Sanitized to \(escapedURL).")
            url = escapedURL
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
