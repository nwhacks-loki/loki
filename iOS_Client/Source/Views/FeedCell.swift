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
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setupViews() {
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
}
