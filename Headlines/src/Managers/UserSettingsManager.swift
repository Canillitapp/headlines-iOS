//
//  UserSettingsManager.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/16/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class UserSettingsManager: NSObject {
    
    var whitelistedSources: [String]? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "whitelisted_sources")
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.stringArray(forKey: "whitelisted_sources")
        }
    }
    
    var shouldOpenNewsInsideApp: Bool {
        guard let value = UserDefaults.standard.value(forKey: "open_news_inside_app") as? Bool else {
            return true
        }
        return value
    }
    
    var firstOpenDate: Date? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "first_open_date")
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.value(forKey: "first_open_date") as! Date?
        }
    }
    
    var canceledReviewDate: Date? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "canceled_review_date")
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.value(forKey: "canceled_review_date") as! Date?
        }
    }
    
    var reviewDate: Date? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "review_date")
            UserDefaults.standard.synchronize()
        }
        
        get {
            return UserDefaults.standard.value(forKey: "review_date") as! Date?
        }
    }
}
