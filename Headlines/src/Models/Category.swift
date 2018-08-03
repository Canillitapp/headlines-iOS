//
//  Category.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class Category: Decodable {
    
    let identifier: Int
    let name: String
    var imageURL: URL?
    
    init(identifier: Int, name: String, imageURL: URL?) {
        self.identifier = identifier
        self.name = name
        self.imageURL = imageURL
    }
    
    // MARK: - Decodable
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case imageURL = "img_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(Int.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
    }
}
