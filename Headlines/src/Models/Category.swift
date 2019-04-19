//
//  Category.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class Category: Decodable {

    // Required
    let identifier: String
    let name: String

    // Optional
    var imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case imageURL = "img_url"
    }
    
    init(identifier: String, name: String, imageURL: URL?) {
        self.identifier = identifier
        self.name = name
        self.imageURL = imageURL
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Required
        identifier = "\(try values.decode(Int.self, forKey: .identifier))"
        name = try values.decode(String.self, forKey: .name)

        // Optional
        imageURL = try? values.decode(URL.self, forKey: .imageURL)
    }
}
