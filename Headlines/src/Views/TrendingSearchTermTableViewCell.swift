//
//  TrendingSearchTermTableViewCell.swift
//  Canillitapp
//
//  Created by Marcos Griselli on 06/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class TrendingSearchTermTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        textLabel?.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        textLabel?.font = UIFont.systemFont(ofSize: 21, weight: UIFontWeightRegular)
    }
}
