//
//  DynamicHeightCollectionView.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/14/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}
