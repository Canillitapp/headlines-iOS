//
//  TopicList.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 06/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

class TopicList: Decodable {

    let keywords: [String]
    let topics: [Topic]

    enum CodingKeys: String, CodingKey {
        case keywords
        case news
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        keywords = try values.decode([String].self, forKey: .keywords)

        // Safely parse news and discard the ones that cannot be parsed
        let safeNews = try values.decode([String: [Throwable<News>]].self, forKey: .news)
        let news = safeNews.compactMapValues { throwables -> [News]? in
            return throwables.compactMap({ t -> News? in
                return t.value
            })
        }

        /**
         *  Transform each [String: [News]] into Topic and then sort it
         *  from most recent news to oldest news.
         */

        topics = news.map({ (k, v) -> Topic in
            return Topic(name: k, news: v)
        }).sorted(by: { (a, b) -> Bool in
            guard let dateA = a.news?.first?.date, let dateB = b.news?.first?.date else {
                return false
            }

            return dateA.compare(dateB) == .orderedDescending
        })
    }
}
