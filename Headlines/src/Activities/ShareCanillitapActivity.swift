//
//  ShareURLActivity.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 01/03/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class ShareCanillitapActivity: UIActivity {

    // MARK: Properties
    override var activityTitle: String? { return "Compartir URL" }
    override var activityType: UIActivity.ActivityType? { return UIActivity.ActivityType(rawValue: "Canillitapp URL") }
    override class var activityCategory: UIActivity.Category { return .action }
    override var activityImage: UIImage? { return UIImage(named: "icon_activity_share") }

    var news: News

    class func canillitappURL(fromNews news: News) -> String {
        return "https://www.canillitapp.com/article/\(news.identifier)?source=iOS"
    }

    // MARK: Initializer
    init(withNews news: News) {
        self.news = news
        super.init()
    }

    // MARK: Overrides
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        // Nothing to prepare
    }

    override func perform() {
        UIPasteboard.general.string = ShareCanillitapActivity.canillitappURL(fromNews: self.news)
        activityDidFinish(true)
    }
}
