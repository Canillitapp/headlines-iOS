//
//  NewsRowController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/24/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import WatchKit

class NewsRowController: NSObject {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var sourceLabel: WKInterfaceLabel!
    @IBOutlet var timeLabel: WKInterfaceLabel!
    
    var date: Date? {
        didSet {
            if let date = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let timeString = formatter.string(from: date)
                
                timeLabel.setText(timeString)
            } else {
                timeLabel.setText("")
            }
        }
    }
}
