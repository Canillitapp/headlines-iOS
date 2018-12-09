//
//  TopicHeaderViewModel.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 08/12/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class TopicHeaderViewModel {
    let topic: Topic
    
    var dateString: String {
        guard let date = topic.date else {
            return "-"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: date)
    }
    
    var title: String {
        return topic.name ?? "Sin Título"
    }
    
    var quantity: String {
        let q = topic.news?.count ?? 1
        return "\(q) noticias"
    }
    
    init(topic: Topic) {
        self.topic = topic
    }
}
