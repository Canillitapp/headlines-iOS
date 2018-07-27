//
//  Safe.swift
//  Headlines
//
//  Created by Marcos Griselli on 25/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Base.self)
        } catch {
            assertionFailure("ERROR: \(error)")
//            Crashlytics.sharedInstance().recordError(error)
            value = nil
        }
    }
}
