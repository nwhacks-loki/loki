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
    
    let header = Header()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    let footer = Footer()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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
        
        clipsToBounds = true
        backgroundColor = .white
        
        addSubview(separatorLine)
        addSubview(header)
        addSubview(imageView)
        addSubview(contentTextView)
        addSubview(footer)
        
        header.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        imageView.anchor(header.bottomAnchor, left: leftAnchor, bottom: contentTextView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        contentTextView.anchor(imageView.bottomAnchor, left: leftAnchor, bottom: footer.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        footer.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        separatorLine.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, heightConstant: 0.5)
    }
    
}
