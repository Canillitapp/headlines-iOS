//
//  ReviewBannerViewModel.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 31/12/2017.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class ReviewBannerViewModel: NSObject {
    
    let userManager = UserSettingsManager()
    
    func shouldShowBanner() -> Bool {
        guard let firstOpenDate = userManager.firstOpenDate else {
            return false
        }
        
        //  Review are only for users on their 3rd day using the app
        let timeIntervalThreshold = 10.0 // 259200.0
        if Date().timeIntervalSince(firstOpenDate) < timeIntervalThreshold {
            return false
        }
        
        return userManager.reviewDate == nil && userManager.canceledReviewDate == nil
    }
}
