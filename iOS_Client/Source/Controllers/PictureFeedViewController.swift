//
//  PictureFeedViewController.swift
//  nwHacks2018
//
//  Created by MAC on 2018-01-13.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class PictureFeedViewController: UITableViewController {
    
    var randomNum: UInt32 {
        return arc4random_uniform(4) + 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if (randomNum == 0) {
            cell.imageView?.image = UIImage(named:("happy\(randomNum)"))
        } else if (randomNum == 1) {
            cell.imageView?.image = UIImage(named:("sad\(randomNum)"))
        } else if (randomNum == 2) {
            cell.imageView?.image = UIImage(named:("angry\(randomNum)"))
        } else {
            cell.imageView?.image = UIImage(named:("surprise\(randomNum)"))
        }
        
        return cell
    }
    
}
