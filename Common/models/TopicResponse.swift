//
//  TopicResponse.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 21/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

struct TopicResponse: Decodable {
    let keywords: [String]
    let news: [String: [News]]
    
    func topics(date: Date) -> [Topic] {
        return news.map { news -> Topic in
            let topic = Topic()
            topic.name = news.key
            topic.date = date
            topic.news = news.value
            return topic
        }
    }
}
