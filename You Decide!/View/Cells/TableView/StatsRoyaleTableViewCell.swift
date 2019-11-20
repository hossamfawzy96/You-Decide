//
//  StatsRoyaleTableViewCell.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
// MARK:- StatsRoyaleTableViewCell
class StatsRoyaleTableViewCell: UITableViewCell{
    
    // MARK:- Outlets
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var losses: UILabel!
    @IBOutlet weak var threeCrownWins: UILabel!
    @IBOutlet weak var totalDonations: UILabel!
    @IBOutlet weak var matchesPlayed: UILabel!
    @IBOutlet weak var winRatePercentage: UILabel!
}
