//
//  TrendingCardsViewController+Review.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 24/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

import Crashlytics

// MARK: Review
extension TrendingCardsViewController {
    
    func setupReviewButtons() {
        reviewButton.layer.borderColor = UIColor.white.cgColor
        reviewButton.layer.borderWidth = 1
        reviewButton.layer.cornerRadius = 8
        
        reviewCancelButton.layer.borderColor = UIColor.white.cgColor
        reviewCancelButton.layer.borderWidth = 1
        reviewCancelButton.layer.cornerRadius = 8
    }
    
    @IBAction func reviewButtonPressed(_ sender: Any) {
        view.layoutIfNeeded()
        reviewHeight.constant = 0
        let animation = { [unowned self] in
            self.reviewView.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        let completion: (Bool) -> Void = { [unowned self] (completed) in
            self.reviewView.isHidden = true
            self.userSettingsManager.reviewDate = Date()
            Answers.logCustomEvent(withName: "review_accept", customAttributes: nil)
            SKStoreReviewController.requestReview()
        }
        
        UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
    }
    
    @IBAction func reviewCancelButtonPressed(_ sender: Any) {
        view.layoutIfNeeded()
        reviewHeight.constant = 0
        let animation = { [unowned self] in
            self.reviewView.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        let completion: (Bool) -> Void = { [unowned self] (completed) in
            self.reviewView.isHidden = true
            self.userSettingsManager.canceledReviewDate = Date()
            Answers.logCustomEvent(withName: "review_cancel", customAttributes: nil)
        }
        
        UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
    }
}
