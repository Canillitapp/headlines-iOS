//
//  Array + Util.swift
//  HeadlinesTests
//
//  Created by Marcos Griselli on 13/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

public extension Array where Element: Hashable {

    /// Creates a new array holding only unique elements.
    /// It uses the insert(_ newMember: Set.Element) -> (inserted: Bool, memberAfterInsert: Set.Element)
    /// set method to access the inserted elemenet of a Set<Element>
    ///
    /// - Returns: Array with unique elements
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
