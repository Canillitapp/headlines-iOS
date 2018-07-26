//
//  Reactions.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 3/25/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class Reaction: NSObject, Decodable {
    var reaction: String
    var amount: Int
    var news: News?
    var date: Date
    
    var reactionString: String {
        return "\(self.reaction) \(self.amount)"
    }
    
    // MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case reaction
        case amount
        case news
        case date
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reaction = try container.decode(String.self, forKey: .reaction)
        amount = (try? container.decode(Int.self, forKey: .amount)) ?? 0
        news = try container.decodeIfPresent(News.self, forKey: .news)
        let decodedDate = try container.decode(Int.self, forKey: .date)
        date = Date(timeIntervalSince1970: TimeInterval(decodedDate))
    }
    
    init(reaction: String, amount: Int) {
        self.reaction = reaction
        self.amount = amount
        self.date = Date()
        super.init()
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
            "📷", "🎶", "⚠️", "💤", "🚫", "🏠", "🏭", "🏔"
        ]
    }
}
