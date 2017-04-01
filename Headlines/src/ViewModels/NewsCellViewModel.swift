//
//  NewsCellModelView.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/1/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class NewsCellViewModel: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var news: News
    
    var timeString: String? {
        guard let date = news.date else {
            return nil
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: date)
    }
    
    var title: String? {
        return news.title
    }
    
    var source: String? {
        return news.source
    }
    
    var imageURL: URL? {
        return news.imageUrl
    }
    
    init(news: News) {
        self.news = news
        super.init()
    }
    
    //  MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = news.reactions?.count else {
            return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reactionCell", for: indexPath)
        cell.layer.borderColor = UIColor(white: 236/255.0, alpha: 1).cgColor
        
        if let c = cell as? ReactionCollectionViewCell {
            if let r = news.reactions?[indexPath.row] {
                c.reactionLabel.text = "\(r.reaction) \(r.amount)"
            }
        }
        
        return cell
    }

}
