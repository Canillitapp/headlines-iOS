//
//  Interest.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 28/10/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SwiftyJSON

class Interest {
    var identifier: String
    var tagId: String
    var score: Int
    var name: String

    init?(json: JSON) {
        
        guard let interestId = json["interest_id"].int else {
            return nil
        }
        self.identifier = "\(interestId)"
        
        guard let tagId = json["tag_id"].int else {
            return nil
        }
        self.tagId = "\(tagId)"
        
        guard let name = json["name"].string else {
            return nil
        }
        self.name = name
        
        guard let score = json["score"].int else {
            return nil
        }
        self.score = score
     }
}
