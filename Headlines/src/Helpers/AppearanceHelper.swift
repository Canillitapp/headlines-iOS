//
//  AppearanceHelper.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 05/04/2020.
//  Copyright © 2020 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

class AppearanceHelper {

    static let shared = AppearanceHelper()

    lazy var newsCardTitleFont: UIFont = {
        #if targetEnvironment(macCatalyst)
        return UIFont.systemFont(ofSize: 24)
        #else
        return UIFont.preferredFont(forTextStyle: .title2)
        #endif
    }()

    lazy var newsCardBodyFont: UIFont = {
        #if targetEnvironment(macCatalyst)
        return UIFont.systemFont(ofSize: 19)
        #else
        return UIFont.preferredFont(forTextStyle: .subheadline)
        #endif
    }()

    lazy var newsCellTitleFont: UIFont = {
        #if targetEnvironment(macCatalyst)
        return UIFont.systemFont(ofSize: 19)
        #else
        return UIFont.preferredFont(forTextStyle: .body)
        #endif
    }()

    lazy var newsCellSourceFont: UIFont = {
        #if targetEnvironment(macCatalyst)
        return UIFont.systemFont(ofSize: 19)
        #else
        return UIFont.preferredFont(forTextStyle: .subheadline)
        #endif
    }()

    lazy var reactionFont: UIFont = {
        #if targetEnvironment(macCatalyst)
        return UIFont.systemFont(ofSize: 18)
        #else
        return UIFont.systemFont(ofSize: 14)
        #endif
    }()

    lazy var reactionCellHorizontalPadding: CGFloat = {
        #if targetEnvironment(macCatalyst)
        return 14
        #else
        return 10
        #endif
    }()

    lazy var reactionCellHeight: CGFloat = {
        #if targetEnvironment(macCatalyst)
        return 40
        #else
        return 30
        #endif
    }()
}
