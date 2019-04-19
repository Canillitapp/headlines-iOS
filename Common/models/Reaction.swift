//
//  Reactions.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 3/25/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class Reaction: NSObject, Decodable {

    // Required
    var reaction: String
    var amount: Int
    var date: Date

    // Optional
    var news: News?

    enum CodingKeys: String, CodingKey {
        case reaction
        case amount
        case date
        case news
    }

    var reactionString: String {
        return "\(self.reaction) \(self.amount)"
    }
    
    init(reaction: String, amount: Int) {
        self.reaction = reaction
        self.amount = amount
        self.date = Date()
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Required
        reaction = try values.decode(String.self, forKey: .reaction)
        amount = (try? values.decode(Int.self, forKey: .amount)) ?? 0

        // Optional
        if let timestamp = try? values.decode(TimeInterval.self, forKey: .date) {
            date = Date(timeIntervalSince1970: timestamp)
        } else {
            date = Date()
        }

        news = try? values.decode(News.self, forKey: .news)
    }
    
    override func copy() -> Any {
        let retVal = Reaction(reaction: reaction, amount: amount)
        retVal.date = date
        return retVal
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
            "😝", "🤑", "🤓", "😎", "😏", "😒", "☹️", "😣", "😩", "😡", "😶", "😐", "😯",
            "😦", "😵", "😳", "😱", "😨", "😢", "😭", "😴", "🙄", "🤔", "😬", "🤐", "😷",
            "🤒", "🤕", "😈", "👿", "💩", "👻", "☠️", "👽", "👾", "🤖", "🎃", "😺", "😸",
            "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "👐", "🙌", "👏", "🙏", "👍", "👎",
            "👊", "🤞", "✌️", "🤘", "👌", "🖖", "💪", "🖕", "💅", "❤️", "🧡", "💛", "💚",
            "💙", "💜", "🖤", "💔", "💖", "💯",
            "⭐️", "⚡️", "💥", "🔥", "👳🏽", "👮🏾", "💁🏻", "💁🏻‍♂️", "🙅🏻", "🙅🏻‍♂️", "👯", "🏃🏻", "🐶",
            "🐱", "🐭", "🐰", "🐻", "🐯", "🦁", "🐮", "🐷", "🙈", "🙉", "🙊", "🐴", "🐔",
            "🦄", "🐛", "🐢", "🐍", "🌱", "☀️", "⛅️", "🌧", "🌈", "☕️", "🍷", "🍺", "🍿",
            "🍖", "🌮", "🍔", "🍏", "🍋", "🍊", "🍌", "🍑", "🍆", "⚽️", "🏀", "🎾", "🚗",
            "🚕", "🚌", "🏎", "🚓", "💵", "💰", "💣", "🕹", "📺", "🏆", "🚀", "✈️", "🎉",
            "📷", "🎻", "🎶", "⚠️", "💤", "🚫", "🏠", "🏭", "🏔"
        ]
    }
}
