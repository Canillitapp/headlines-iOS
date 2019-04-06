//
//  TrendingTerm.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 08/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

struct TrendingTerm: Decodable {
    let criteria: String
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case criteria
        case quantity
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        criteria = try values.decode(String.self, forKey: .criteria)
        quantity = try values.decode(Int.self, forKey: .quantity)
    }
}
