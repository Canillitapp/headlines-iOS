//
//  Parser.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 02/09/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class Parser: NSObject {
    
    class func url(from string: String) -> URL? {
        guard let retVal = URL.init(string: string) else {
            return nil
        }
        return retVal
    }

}
