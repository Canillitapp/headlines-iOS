//
//  TrendingTerm.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 08/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TrendingTerm {
    let criteria: String
    let quantity: Int
    
    init?(json: JSON) {
        guard let criteria = json["criteria"].string,
            let quantity = json["quantity"].int else {
                return nil
        }
        self.criteria = criteria
        self.quantity = quantity
    }
}

