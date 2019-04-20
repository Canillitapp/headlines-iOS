//
//  SuggestionsHelper.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 29/11/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class SuggestionsHelper {

    enum ActivityType: String {
        case search = "ar.com.betzerra.headlines.search"
    }

    @available(iOS 12.0, *)
    class func searchActivity(from topic: String) -> NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.search.rawValue)
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "Buscar noticias sobre \"\(topic)\""
        activity.userInfo = ["topic": topic]

        return activity
    }
}
