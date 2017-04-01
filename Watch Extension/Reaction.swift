//
//  Reactions.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 3/25/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class Reaction: NSObject {
    var reaction: String
    var amount: Int
    
    var reactionString: String {
        return "\(self.reaction) \(self.amount)"
    }
    
    init(reaction: String, amount: Int) {
        self.reaction = reaction
        self.amount = amount
        super.init()
    }
    
    class func randomReaction() -> Reaction {
        let emojis = ["🙃", "👍", "👎", "🙄", "🙁", "😺"]
        let emojisRandomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
        let reaction = emojis[emojisRandomIndex]
        
        let amount = Int(arc4random_uniform(UInt32(999)))

        return Reaction(reaction: reaction, amount: amount)
    }
}
