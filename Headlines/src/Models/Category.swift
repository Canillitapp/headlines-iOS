//
//  Category.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 25/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class Category {
    let identifier: String
    let name: String
    var imageURL: URL?
    
    init(identifier: String, name: String, imageURL: URL?) {
        self.identifier = identifier
        self.name = name
        self.imageURL = imageURL
    }
}
