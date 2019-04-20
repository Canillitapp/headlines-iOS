//
//  CategoriesHeader.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 24/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

class CategoriesHeaderView: UICollectionReusableView {
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: CategoriesContainerViewModel? {
        didSet {
            collectionView.delegate = viewModel
            collectionView.dataSource = viewModel
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
}
