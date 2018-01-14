//
//  Header.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/14/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class Header: UIView {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let detailTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
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
    
    func setupViews() {
        
        clipsToBounds = true
        
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(detailTextLabel)
    
        imageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 4, leftConstant: 16, bottomConstant: 4, rightConstant: 0, widthConstant: 42, heightConstant: 0)
        imageView.layer.cornerRadius = 42 / 2
        
        textLabel.anchor(topAnchor, left: imageView.rightAnchor, bottom: detailTextLabel.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        detailTextLabel.anchor(textLabel.bottomAnchor, left: textLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        textLabel.anchorHeightToItem(detailTextLabel)
    }
    
}
