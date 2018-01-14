//
//  Footer.swift
//  nwHacks2018
//
//  Created by Nathan Tannar on 1/14/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class Footer: UIView {
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "fb_like").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(" Like", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .darkGray
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "fc_comment").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(" Comment", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 4, rightConstant: 16, widthConstant: 0, heightConstant: 0)
    }
    
}

