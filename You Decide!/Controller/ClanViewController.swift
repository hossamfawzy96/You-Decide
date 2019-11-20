//
//  ClanViewController.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import CoreData

//MARK:- ClanViewController
class ClanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Properties
    private var dataController: DataController!
    private var clan: Clan!
    private var noClan: Bool = false
    
    //MARK:- Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        dataController = DataControllerSingelton.sharedDataControllerInstance
        
        let clanFetchrequest: NSFetchRequest<Clan> = Clan.fetchRequest()
        if let result = try? self.dataController.viewContext.fetch(clanFetchrequest){
            if(result.count > 0){
                clan = result[0]
            }else{
                noClan = true
            }
        }
    }
}

//MARK:- TableView Functions
extension ClanViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clanTableViewCell = tableView.dequeueReusableCell(withIdentifier: "clanInfo") as! ClanTableViewCell
        if(!noClan){
            clanTableViewCell.badge.image = UIImage(named: clan.badge!)
            clanTableViewCell.clanDescription.text = clan.clanDescription
            clanTableViewCell.clanTag.text = clan.tag
            clanTableViewCell.donations.text = String(clan.donationPerWeek)
            clanTableViewCell.location.text = clan.location
            clanTableViewCell.members.text = String(clan.members)
            clanTableViewCell.nameText.text = clan.name
            clanTableViewCell.score.text = String(clan.clanScore)
            clanTableViewCell.trophies.text = String(clan.clanWarTrophies)
            clanTableViewCell.requiredTrophies.text = String(clan.requiredTrophies)
            clanTableViewCell.type.text = clan.type
        }else{
            clanTableViewCell.badge.image = UIImage(named:"noClan" )
            clanTableViewCell.clanDescription.text = "NA"
            clanTableViewCell.clanTag.text = "NA"
            clanTableViewCell.donations.text = "NA"
            clanTableViewCell.location.text = "NA"
            clanTableViewCell.members.text = "NA"
            clanTableViewCell.nameText.text = "NA"
            clanTableViewCell.score.text = "NA"
            clanTableViewCell.trophies.text = "NA"
            clanTableViewCell.requiredTrophies.text = "NA"
            clanTableViewCell.type.text = "NA"
        }
        
        return clanTableViewCell
    }
}
