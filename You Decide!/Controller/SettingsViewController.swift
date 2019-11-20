//
//  SettingsViewController.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit

//MARK:- SettingsViewController
class SettingsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var `switch`: UISwitch!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        `switch`.setOn((UIApplication.shared.delegate as! AppDelegate).autoLogout!, animated: true)
    }
   
    //MARK:- Actions
    @IBAction func switchDidMove(_ sender: Any) {
        UserDefaults.standard.set(`switch`.isOn, forKey: "autoLogout")
    }
}
