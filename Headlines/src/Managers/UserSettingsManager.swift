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
        return UserDefaults.standard.bool(forKey: "open_news_inside_app")
    }
}
