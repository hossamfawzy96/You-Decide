//
//  ProfileViewController.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import CoreData

//MARK:- ProfileViewController
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    private var dataController: DataController!
    private var player: Player!
    private var cards: [Card]!
    private var chests: [Chest]!
    private var favouriteCard: Card!
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataController = DataControllerSingelton.sharedDataControllerInstance
        
        loadPlayer()
    }
    
    
    //MARK:- Functions
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let cardDetailsController = storyboard.instantiateViewController(withIdentifier: "cardDetails")as! CardDetailsViewController
        
        cardDetailsController.card = favouriteCard
        self.present(cardDetailsController, animated: true)
    }
    
    private func loadPlayer(){
        // Fetch player's info from CoreData
        cards = [Card]()
        chests = [Chest]()
        // Fetch player
        let playerFetchrequest: NSFetchRequest<Player> = Player.fetchRequest()
        if let result = try? self.dataController.viewContext.fetch(playerFetchrequest){
            player = result[0]
            
            // Fetch Cards that belong to the current deck
            let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
            let predicate = NSPredicate(format: "currentDeck == %@", player.currentDeck!)
            
            fetchRequest.predicate = predicate
            
            if let result = try? self.dataController.viewContext.fetch(fetchRequest){
                for card in result{
                    cards.append(card)
                }
            }
        }
        
        //Fetch upcoming chests
        let chestFetchRequest: NSFetchRequest<Chest> = Chest.fetchRequest()
        if let chestsResult = try? self.dataController.viewContext.fetch(chestFetchRequest){
            for chest in chestsResult{
                chests.append(chest)
            }
        }
    }
    
    private func refreshFailed(message: String){
        AlertViewController().showError(title: "refresh Failed",message: message, parent: self)
    }
    
    //MARK:- Actions
    @IBAction func refresh(_ sender: Any) {
        let spinner = SpinnerViewController()
        spinner.createSpinnerView(parent: self)
        
        ClashRoyaleClient.sharedInstance().loadInfo(dataController: dataController, playerTag: player.tag!){(success,error) in
            DispatchQueue.main.async{
                spinner.removeSpinnerView()
                if(success){
                    self.dataController.viewContext.delete(self.player)
                    
                    self.loadPlayer()
                    
                    self.tableView.reloadData()
                }else{
                    self.refreshFailed(message: error!)
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        dataController.viewContext.delete(player)
        
        UserDefaults.standard.set(true, forKey: "autoLogout")
        
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- TableView Extension
extension ProfileViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if(row == 0){
            return 130
        }else if(row == 1){
            return 200
        }else if(row == 5){
            return 150
        }else if(row == 6){
            return 250
        }else if(row == 7){
            return 150
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if(row == 0){
            let profileInfoCell = tableView.dequeueReusableCell(withIdentifier: "playerInfo") as! PlayerInfoTableViewCell
            
            profileInfoCell.name.text = player.name
            profileInfoCell.playerTag.text = player.tag
            profileInfoCell.highestTrophies.text = String(player.bestSeasonTrophies)
            profileInfoCell.currentTrophies.text = String(player.trophies)
            profileInfoCell.expLevel.image = UIImage(named: "\(player.expLevel)")
            
            return profileInfoCell
        }else if(row == 1){
            let statsRoyaleCell = tableView.dequeueReusableCell(withIdentifier: "statsRoyale") as! StatsRoyaleTableViewCell
            
            statsRoyaleCell.wins.text = String(player.wins)
            statsRoyaleCell.losses.text = String(player.losses)
            statsRoyaleCell.threeCrownWins.text = String(player.threeCrownWins)
            statsRoyaleCell.totalDonations.text = String(player.totalDonations)
            statsRoyaleCell.matchesPlayed.text = String(player.battleCount)
            
            let playerWins = Int(player!.wins)
            let playerBattles = Int(player!.wins + player!.losses)
            
            statsRoyaleCell.winRatePercentage.text = String(format: "%.2f",Float(playerWins)/Float(playerBattles) * 100)+"%"
            return statsRoyaleCell
        }else if(row == 2){
            let clanWarStatsCell = tableView.dequeueReusableCell(withIdentifier: "clanWarStats") as! ClanWarStatsTableViewCell
            
            clanWarStatsCell.cardsCollected.text = String(player.clanCardsCollected)
            clanWarStatsCell.warDayWins.text = String(player.warDayWins)
            
            return clanWarStatsCell
        }else if(row == 3){
            let challengeStatsCell = tableView.dequeueReusableCell(withIdentifier: "challengeStats") as! ChallengeStatsTableViewCell
            
            challengeStatsCell.cardsCollected.text = String(player.challengeCardsWon)
            challengeStatsCell.maxWins.text = String(player.challengeMaxWins)
            
            return challengeStatsCell
        }else if(row == 4){
            let tournamentStatsCell = tableView.dequeueReusableCell(withIdentifier: "tournamentStats") as! TournamentStatsTableViewCell
            
            tournamentStatsCell.cardsWon.text = String(player.tournamentCardWon)
            tournamentStatsCell.matchesPlayed.text = String(player.tournamentBattleCount)
            
            return tournamentStatsCell
        }else if(row == 5){
            let favouriteCardCell = tableView.dequeueReusableCell(withIdentifier: "favouriteCard") as! FavouriteCardTableViewCell
            
            let favouriteCardName = player.favouriteCard
            
            favouriteCardCell.cardName.text = favouriteCardName
            
            let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
            let predicateName = NSPredicate(format: "name == %@", favouriteCardName!)
            
            fetchRequest.predicate = predicateName
            
            if let result = try? dataController.viewContext.fetch(fetchRequest){
                favouriteCard = result[0]
                favouriteCardCell.cardIcon.image = UIImage(data: result[0].icon!)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                favouriteCardCell.cardIcon.isUserInteractionEnabled = true
                favouriteCardCell.cardIcon.addGestureRecognizer(tapGestureRecognizer)
            }
            
            return favouriteCardCell
        }else if(row == 6){
            
            let deckCell = tableView.dequeueReusableCell(withIdentifier: "deckcell") as! DeckTableViewCell
            
            return deckCell
        }else{
            let chestCell = tableView.dequeueReusableCell(withIdentifier: "chestscell") as! ChestsTableViewCell
            
            return chestCell
        }
    }
}

//MARK:- CollectionView Extension
extension ProfileViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let ID = collectionView.accessibilityIdentifier!
        
        if(ID == "deck"){
            return cards.count
        }else{
            return chests.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ID = collectionView.accessibilityIdentifier!
        if(ID == "deck"){
            let cardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
            
            let card = cards[indexPath.row]
            cardCollectionViewCell.cardIcon.image = UIImage(data: card.icon!)
            
            return cardCollectionViewCell
        }else{
            let chestCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "chestCell", for: indexPath) as! ChestCollectionViewCell
            
            let chest = chests[indexPath.row]
            
            chestCollectionViewCell.icon.image = UIImage(named: chest.name!)
            chestCollectionViewCell.index.text = "+\(String(chest.index))"
            
            return chestCollectionViewCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ID = collectionView.accessibilityIdentifier
        
        if(ID == "deck"){
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let cardDetailsController = storyboard.instantiateViewController(withIdentifier: "cardDetails")as! CardDetailsViewController
            
            cardDetailsController.card = cards[indexPath.row]
            self.present(cardDetailsController, animated: true)
        }
    }
    
}
