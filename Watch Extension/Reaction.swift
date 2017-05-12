//
//  Reactions.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 3/25/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SwiftyJSON

class Reaction: NSObject {
    var reaction: String
    var amount: Int
    var news: News?
    var date: Date
    
    var reactionString: String {
        return "\(self.reaction) \(self.amount)"
    }
    
    init(json: JSON) {
        
        if let r = json["reaction"].string {
            reaction = r
        } else {
            reaction = "🤦🏿‍♂️"
        }
        
        if let i = json["amount"].int {
            amount = i
        } else {
            amount = 0
        }
        
        let timestamp = json["date"].doubleValue
        date = Date(timeIntervalSince1970: timestamp)
        
        if json["news"].exists() {
            news = News(json: json["news"])
        }

        super.init()
    }
    
    init(reaction: String, amount: Int) {
        self.reaction = reaction
        self.amount = amount
        self.date = Date()
        super.init()
    }
    
    class func randomReaction() -> Reaction {
        let emojis = availableReactions()
        let emojisRandomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
        let reaction = emojis[emojisRandomIndex]
        
        let amount = Int(arc4random_uniform(UInt32(999)))

        return Reaction(reaction: reaction, amount: amount)
    }
    
    class func availableReactions() -> [String] {
        return [
            "😀", "😄", "😆", "😅", "😂", "😊", "😇", "🙂", "🙃", "😍", "😘", "😗", "😜",
            "😝", "🤑", "🤓", "😎", "🤡", "🤠", "😏", "😒", "☹️", "😣", "😩", "😡", "😶",
            "😐", "😯", "😦", "😵", "😳", "😱", "😨", "😢", "🤤", "😭", "😴", "🙄", "🤔",
            "🤥", "😬", "🤐", "🤢", "😷", "🤒", "🤕", "😈", "👿", "💩", "👻", "☠️", "👽",
            "👾", "🤖", "🎃", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "👐",
            "🙌", "👏", "🙏", "🤝", "👍", "👎", "👊", "🤞", "✌️", "🤘", "👌", "🖖", "💪",
            "🖕", "💅", "❤️", "💔", "💖", "💯", "⭐️", "⚡️", "💥", "🔥", "👳🏽", "👮🏾", "💁🏻",
            "💁🏻‍♂️", "🙅🏻", "🙅🏻‍♂️", "🤦🏻‍♀️", "🤦🏻‍♂️", "🤷🏻‍♀️", "🤷🏻‍♂️", "👯", "🏃🏻", "🐶", "🐱", "🐭", "🐰",
            "🐻", "🐯", "🦁", "🐮", "🐷", "🙈", "🙉", "🙊", "🐴", "🐔", "🦄", "🐛", "🐢",
            "🐍", "🌱", "☀️", "⛅️", "🌧", "☕️", "🍏", "🍋", "🍊", "🍌", "🍑", "🍆", "🥑",
            "⚽️", "🏀", "🎾", "🚗", "🚕", "🚌", "🏎", "🚓", "💵", "💰", "💣", "🕹", "📺",
            "📷", "🎶", "⚠️", "💤", "🚫", "🏠", "🏭", "🏔", "🇦🇷"
        ]
    }
}
