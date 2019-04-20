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

// MARK: Review
extension TrendingCardsViewController: ReviewViewDelegate {

    func setupReviewView() {
        guard let view = ReviewView.loadViewFromNib() as? ReviewView,
            reviewViewModel.shouldShowBanner() else {
            return
        }

        view.delegate = self
        mainStackView.insertArrangedSubview(view, at: 0)
        reviewView = view
    }

    func reviewViewDidAccept(_ view: ReviewView) {
        self.userSettingsManager.reviewDate = Date()
        SKStoreReviewController.requestReview()

    }

    func reviewViewDidCancel(_ view: ReviewView) {
        self.userSettingsManager.canceledReviewDate = Date()
    }
}
