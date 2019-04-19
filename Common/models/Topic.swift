//
//  Keyword.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 11/16/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation

class Topic: NSObject, Decodable {
    var name: String?
    var date: Date?
    var news: [News]?

    enum CodingKeys: String, CodingKey {
        case name
        case date
        case news
    }

    var representativeReaction: Reaction? {
        var reactionMap = [String: Reaction]()
        news?.forEach({ (n) in
            n.reactions?.forEach({ (r) in
                guard let fetchedReaction = reactionMap[r.reaction] else {
                    reactionMap[r.reaction] = r.copy() as? Reaction
                    return
                }
                fetchedReaction.amount += r.amount
            })
        })
        
        let sortedReactions = reactionMap.values.sorted { return $0.amount > $1.amount }
        return sortedReactions.first
    }

    required init(name: String, news: [News]) {
        self.name = name
        self.news = news
        self.date = news.first?.date
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try? values.decode(String.self, forKey: .name)
        date = try? values.decode(Date.self, forKey: .date)
        news = try? values.decode([News].self, forKey: .news)
    }
}
