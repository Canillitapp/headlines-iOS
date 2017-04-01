//
//  NewsCellModelView.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/1/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class NewsCellViewModel: NSObject,
                        UICollectionViewDataSource,
                        UICollectionViewDelegate,
                        UICollectionViewDelegateFlowLayout {
    
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
            return 1
        }
        
        return count+1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let reactions = news.reactions else {
            return UICollectionViewCell()
        }
        
        if indexPath.row >= reactions.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
            cell.layer.borderColor = UIColor(white: 236/255.0, alpha: 1).cgColor
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reactionCell", for: indexPath)
            cell.layer.borderColor = UIColor(white: 236/255.0, alpha: 1).cgColor
            
            if let c = cell as? ReactionCollectionViewCell {
                let r = reactions[indexPath.row]
                c.reactionLabel.text = r.reactionString
            }
            return cell
        }
    }
    
    //  MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard indexPath.row < (news.reactions?.count)!,
            let r = news.reactions?[indexPath.row] else {
            return CGSize(width: 30, height: 30)
        }
        
        let size = CGSize(width: Double.greatestFiniteMagnitude, height: 30)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        
        let width = NSString(string: r.reactionString).boundingRect(with: size,
                                                                    options: options,
                                                                    attributes: attributes,
                                                                    context: nil).size.width
        return CGSize(width: width + 10, height: 30)
    }
}