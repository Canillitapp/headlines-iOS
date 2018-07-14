//
//  SuggestedTermTableViewCell.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 14/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class SuggestedTermTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    func set(tag: Tag, searchedTerm: String) {
        let attributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor(white: 0.56, alpha: 1.0)
        ]
        let attributedString = NSAttributedString(
            string: tag.name.lowercased(),
            attributes: attributes
        )
        let mutableAttributedString = NSMutableAttributedString(
            attributedString: attributedString
        )
        mutableAttributedString.setBold(text: searchedTerm.lowercased())
        label.attributedText = mutableAttributedString
    }
}

extension NSMutableAttributedString {
    
    public func setBold(text: String) {
        let foundRange = mutableString.range(of: text)
        if foundRange.location != NSNotFound {
            addAttribute(
                NSAttributedStringKey.foregroundColor,
                value: UIColor.black,
                range: foundRange
            )
        }
    }
}
