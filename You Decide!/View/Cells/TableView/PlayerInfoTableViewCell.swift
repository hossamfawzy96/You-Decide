//
//  PlayerInfoCell.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
// MARK:- PlayerInfoTableViewCell
class PlayerInfoTableViewCell: UITableViewCell{
    
    // MARK:- Outlets
    @IBOutlet weak var expLevel: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var playerTag: UILabel!
    @IBOutlet weak var currentTrophies: UILabel!
    @IBOutlet weak var highestTrophies: UILabel!
}
