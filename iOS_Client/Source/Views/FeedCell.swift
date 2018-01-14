//
//  FeedCell.swift
//  nwHacks2018
//
//  Created by MAC on 2018-01-14.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    class var reuseIdentifier: String {
        return "FeedCell"
    }
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
