//
//  TabbedBarViewController.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/12/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit

//MARK:- TabbedBarViewController
class TabbedBarViewController: UITabBarController {
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItems()
    }
    
    //MARK:- Functions
    private func setTabBarItems(){
        
        let profile = (self.tabBar.items?[0])! as UITabBarItem
        profile.image = UIImage(named: "profile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        profile.selectedImage = UIImage(named: "profile ")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        profile.title = "Profile"
        
        let clan = (self.tabBar.items?[1])! as UITabBarItem
        clan.image = UIImage(named: "clan")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        clan.selectedImage = UIImage(named: "clan ")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        clan.title = "Clan"
        
        let cards = (self.tabBar.items?[2])! as UITabBarItem
        cards.image = UIImage(named: "card-deck")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        cards.selectedImage = UIImage(named: "cards-deck ")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        cards.title = "Cards"
        
        let settings = (self.tabBar.items?[3])! as UITabBarItem
        settings.image = UIImage(named: "settings")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        settings.selectedImage = UIImage(named: "settings ")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        settings.title = "Settings"
    }
}
