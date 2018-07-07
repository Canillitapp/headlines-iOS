//
//  Category.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category {
    let identifier: String
    let name: String
    var imageURL: URL?
    
    init(identifier: String, name: String, imageURL: URL?) {
        self.identifier = identifier
        self.name = name
        self.imageURL = imageURL
    }
    
    init(json: JSON) {
        
        if let categoryId = json["id"].int {
            identifier = "\(categoryId)"
        } else {
            identifier = ""
        }
        
        if let categoryName = json["name"].string {
            name = categoryName
        } else {
            name = ""
        }
        
        imageURL = json["img_url"].URL
    }
}
