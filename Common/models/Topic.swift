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
}
