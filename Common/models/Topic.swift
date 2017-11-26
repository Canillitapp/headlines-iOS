//
//  Keyword.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 11/16/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation

class Topic: NSObject {
    var name: String?
    var date: Date?
    var news: [News]?
    
    var representativeReaction: Reaction? {
        var items = news?.map({ $0.representativeReaction })
        items?.sort(by: { (reactionA, reactionB) -> Bool in
            let amountA = reactionA?.amount ?? 0
            let amountB = reactionB?.amount ?? 0
            return amountA > amountB
        })
        
        guard let r = items else {
            return nil
        }
        
        return r.first as? Reaction
    }
}
