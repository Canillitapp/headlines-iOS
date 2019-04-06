//
//  Interest.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 28/10/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class Interest: Decodable {
    var identifier: String
    var tagId: String
    var score: Int
    var name: String

    enum CodingKeys: String, CodingKey {
        case identifier = "interest_id"
        case tagId = "tag_id"
        case score
        case name
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Required
        identifier = "\(try values.decode(Int.self, forKey: .identifier))"
        tagId = "\(try values.decode(Int.self, forKey: .tagId))"
        score = try values.decode(Int.self, forKey: .score)
        name = try values.decode(String.self, forKey: .name)
    }
}
