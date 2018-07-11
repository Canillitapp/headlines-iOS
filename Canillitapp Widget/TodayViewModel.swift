//
//  TodayViewModel.swift
//  Canillitapp Widget
//
//  Created by Ezequiel Becerra on 01/12/2017.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class TodayViewModel: NSObject {

    let boldTitleFont = UIFont.boldSystemFont(ofSize: 14)
    let regularTitleFont = UIFont.systemFont(ofSize: 14)
    let paragraphStyle = NSMutableParagraphStyle()
    
    var topics: [Topic]?
    
    var attributedTitles: [NSAttributedString]? {
        let retVal = topics?.map({ (aTopic) -> NSAttributedString in
            let topicTitle = self.attributedTitle(fromTopic: aTopic)
            let topicEmoji = self.attributedEmoji(fromTopic: aTopic)
            let topicCount = self.attributedCount(fromTopic: aTopic)

            let attributedSpace = NSAttributedString(
                string: " ",
                attributes: [NSAttributedStringKey.font: regularTitleFont]
            )
            
            let retVal = NSMutableAttributedString(attributedString: topicTitle)
            
            if topicEmoji != nil {
                retVal.append(attributedSpace)
                retVal.append(topicEmoji!)
            }
            
            retVal.append(attributedSpace)
            retVal.append(topicCount)
            return retVal
        })
        
        return retVal
    }
    
    var attributedTitlesString: NSAttributedString? {
        let attributedNewLine = NSAttributedString(
            string: "\n",
            attributes: [NSAttributedStringKey.font: regularTitleFont]
        )
        
        guard let titles = attributedTitles else {
            return nil
        }
        
        let maxElements = min(5, titles.count)
        
        let retVal = titles[0..<maxElements].reduce(
        NSMutableAttributedString(), { (result, title) -> NSMutableAttributedString in
            result.append(title)
            result.append(attributedNewLine)
            return result
        })
        
        return retVal
    }
    
    func attributedTitle(fromTopic topic: Topic) -> NSAttributedString {
        return NSAttributedString(
            string: topic.name?.capitalized ?? "nil_topic",
            attributes: [
                NSAttributedStringKey.font: boldTitleFont,
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ]
        )
    }
    
    func attributedEmoji(fromTopic topic: Topic) -> NSAttributedString? {
        
        guard let reaction = topic.representativeReaction?.reaction else {
            return nil
        }
        
        return NSAttributedString(
            string: reaction,
            attributes: [
                NSAttributedStringKey.font: regularTitleFont,
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ]
        )
    }
    
    func attributedCount(fromTopic topic: Topic) -> NSAttributedString {
        return NSAttributedString(
            string: "(\(topic.news?.count ?? 0))",
            attributes: [
                NSAttributedStringKey.font: regularTitleFont,
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ]
        )
    }
    
    override init() {
        paragraphStyle.lineSpacing = 3.0
        super.init()
    }
    
}
