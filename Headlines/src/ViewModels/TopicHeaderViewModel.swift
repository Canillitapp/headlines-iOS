//
//  TopicHeaderViewModel.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 08/12/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class TopicHeaderViewModel {
    
    let news: [News]
    
    var dateString: String {
        guard let date = news.first?.date else {
            return "-"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: date)
    }
    
    var quantity: String {
        let q = news.count
        return "\(q) noticias"
    }
    
    init(news: [News]) {
        self.news = news
    }
}
