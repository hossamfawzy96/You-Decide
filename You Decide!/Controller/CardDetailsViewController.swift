//
//  CardDetailsViewController.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit

//MARK:- CardDetailsViewController
class CardDetailsViewController: UIViewController {
    
    //MARK:- Properties
    var card: Card!
    
    //MARK:- Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var maxLevel: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        icon.image = UIImage(data: card.icon!)
        name.text = card.name
        level.text = String(card.level)
        count.text = String(card.count)
        maxLevel.text = String(card.maxLevel)
    }
}
