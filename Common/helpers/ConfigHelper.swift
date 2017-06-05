//
//  File.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 5/3/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation

class ConfigHelper {
    
    class func configForKey(_ key: String) -> Any? {
        guard let url = Bundle.main.url(forResource:"config", withExtension: "plist") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf:url)
            let dict = try PropertyListSerialization.propertyList(from: data,
                                                                  options: [],
                                                                  format: nil) as! [String:Any]
            return dict[key]
        } catch {
            return nil
        }
    }
}
