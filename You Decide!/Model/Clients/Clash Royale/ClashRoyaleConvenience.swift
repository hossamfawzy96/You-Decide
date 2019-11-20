//
//  ClashRoyaleConvenience.swift
//  Capstone App
//
//  Created by Hossameldien Hamada on 11/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation
import CoreData

//MARK:- ClashRoyale Convenient Resource Methods
extension ClashRoyaleClient{
    
    //MARK:- loadInfo
    func loadInfo(dataController: DataController, playerTag: String, completionHandlerForLoadInfo: @escaping(_ success: Bool, _ error: String?) -> Void){
        
        // Load Player Info
        let _ = taskForGetMethod(substituteKeyInMethod(Methods.Players, key: "tag", value: playerTag)!){ (response, error) in
            if let error = error{
                completionHandlerForLoadInfo(false, error.userInfo[NSLocalizedDescriptionKey] as? String)
            }else{
                guard let cards = response?[ClashRoyaleResponseKeys.Cards] as? [[String: AnyObject]] else{
                    completionHandlerForLoadInfo(false,"Error occured and cannot fetch cards")
                    return
                }
                
                let player = self.createPlayer(response, completionHandlerForLoadInfo, dataController)
                
                self.createCards(player,cards,completionHandlerForLoadInfo,dataController)
                
                self.createCurrentDeck(response,player,completionHandlerForLoadInfo, dataController)
                
                if let clan = response?[ClashRoyaleResponseKeys.Clan] as? [String:AnyObject]{
                    
                    guard let clanTag = clan[ClashRoyaleResponseKeys.Tag] as? String else{
                        completionHandlerForLoadInfo(false,"Error occured and cannot fetch clan")
                        return
                    }

                    self.createClan(player, clanTag, completionHandlerForLoadInfo, dataController)
                }else{
                    self.loadUpcomingChests(player, playerTag, completionHandlerForLoadInfo, dataController)
                }
            }
        }
    }
    
    //MARK:- createCurrentDeck
    private func createCurrentDeck(_ response: AnyObject? ,_ player: Player, _ completionHandlerForCreateCurrentDeck:@escaping(_ success: Bool, _ error: String?) -> Void, _ dataController: DataController){
        
        guard let currentDeck = response?[ClashRoyaleResponseKeys.currentDeck] as? [[String:AnyObject]] else{
            completionHandlerForCreateCurrentDeck(false,"Error occured and cannot create current deck")
            return
        }
        
        dataController.viewContext.perform {
            let deck = CurrentDeck(context: dataController.viewContext)
            
            for card in currentDeck{
                guard let name = card[CardKeys.Name] as? String else{
                    completionHandlerForCreateCurrentDeck(false,"Error occured and cannot create current deck")
                    return
                }
                
                let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
                let predicateName = NSPredicate(format: "name == %@", name)
                
                fetchRequest.predicate = predicateName
                
                if let result = try? dataController.viewContext.fetch(fetchRequest){
                    deck.addToCards(result[0])
                }
            }
            
            player.currentDeck = deck
            
            do{
                try dataController.viewContext.save()
            }catch{
                fatalError(error.localizedDescription)
            }
            
        }
    }
    
    //MARK:- createCards
    private func createCards(_ player: Player,_ cards:[[String: AnyObject]] ,_ completionHandlerForCreateCards:@escaping(_ success: Bool, _ error: String?) -> Void, _ dataController: DataController){
        
        for card in cards{
            guard let name = card[CardKeys.Name] as? String else{
                completionHandlerForCreateCards(false,"Error occured and cannot fetch cards")
                return
            }
            
            guard let level = card[CardKeys.Level] as? Int64 else{
                completionHandlerForCreateCards(false,"Error occured and cannot fetch cards")
                return
            }
            
            guard let maxLevel = card[CardKeys.MaxLevel] as? Int64 else{
                completionHandlerForCreateCards(false,"Error occured and cannot fetch cards")
                return
            }
            
            guard let count = card[CardKeys.Count] as? Int64 else{
                completionHandlerForCreateCards(false,"Error occured and cannot fetch cards")
                return
            }
            guard let iconURLs = card[CardKeys.IconURLs] as? [String : AnyObject] else{
                completionHandlerForCreateCards(false,"Error occured and cannot fetch cards")
                return
            }
            
            guard let iconMediumURL = iconURLs[IconURLsKeys.Medium] as? String else{
                completionHandlerForCreateCards(false,"Error occured and cannot fetch cards")
                return
            }
            
            let iconURL = URL(string: iconMediumURL)
            if let iconData = try? Data(contentsOf: iconURL!){
                dataController.viewContext.perform {
                    let card = Card(context: dataController.viewContext)
                    
                    card.name = name
                    card.level = level
                    card.maxLevel = maxLevel
                    card.count = count
                    card.icon = iconData
                    
                    player.addToCards(card)
                    
                    do{
                        try dataController.viewContext.save()
                    }catch{
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //MARK:- createPlayer
    private func createPlayer(_ response: AnyObject? ,_ completionHandlerForCreatePlayer:@escaping(_ success: Bool, _ error: String?) -> Void, _ dataController: DataController) -> Player{
        
        let player = Player(context: dataController.viewContext)
        
        guard let tag = response?[ClashRoyaleResponseKeys.Tag] as? String else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: tag")
            return player
        }
        guard let name = response?[ClashRoyaleResponseKeys.Name] as? String else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: name")
            return player
        }
        
        guard let expLevel = response?[ClashRoyaleResponseKeys.EXPLevel] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: expLevel")
            return player
        }
        
        guard let wins = response?[ClashRoyaleResponseKeys.Wins] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: wins")
            return player
        }
        
        guard let losses = response?[ClashRoyaleResponseKeys.Losses] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player losses")
            return player
        }
        
        guard let battleCount = response?[ClashRoyaleResponseKeys.BattleCount] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: battleCount")
            return player
        }
        
        guard let threeCrownWins = response?[ClashRoyaleResponseKeys.ThreeCrownWins] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: threeCrownWins")
            return player
        }
        
        guard let challengeCardWon = response?[ClashRoyaleResponseKeys.ChallengeCardsWon] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: challengeCardWon")
            return player
        }
        
        guard let challengeMaxWins = response?[ClashRoyaleResponseKeys.ChallengeMaxWins] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: challengeMaxWins")
            return player
        }
        
        guard let tournamentCardWon = response?[ClashRoyaleResponseKeys.TournamentCardsWon] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player:tournamentCardWon")
            return player
        }
        
        guard let tournamentBattleCount = response?[ClashRoyaleResponseKeys.TournamentBattleCount] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: tournamentBattleCount")
            return player
        }
        
        guard response?[ClashRoyaleResponseKeys.Role]! != nil && response?[ClashRoyaleResponseKeys.Clan]! != nil || response?[ClashRoyaleResponseKeys.Role]! == nil && response?[ClashRoyaleResponseKeys.Clan]! == nil else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: Clan Role")
            return player
        }
        
        if let clanRole =  response?[ClashRoyaleResponseKeys.Role] as? String{
            player.role = clanRole
        }
        
        guard let donations = response?[ClashRoyaleResponseKeys.Donations] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: donations")
            return player
        }
        
        guard let favouriteCard = response?[ClashRoyaleResponseKeys.CurrentFavouriteCard] as? [String:AnyObject] else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: favouritecard")
            return player
        }
        
        guard let favouriteCardName = favouriteCard[CardKeys.Name] as? String else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: favouritecardname")
            return player
        }
        
        guard let donationsReceived = response?[ClashRoyaleResponseKeys.DonationsReceived] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: donationsReceived")
            return player
        }
        
        guard let totalDonations = response?[ClashRoyaleResponseKeys.TotalDonations] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: totalDonations")
            return player
        }
        
        guard let warDayWins = response?[ClashRoyaleResponseKeys.WarDayWins] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: warDayWins")
            return player
        }
        
        guard let clanCardsCollected = response?[ClashRoyaleResponseKeys.ClanCardsCollected] as? Int64 else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: clanCardsCollected")
            return player
        }
        
        guard let arena = response?[ClashRoyaleResponseKeys.Arena] as? [String:AnyObject] else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: arena")
            return player
        }
        
        guard let arenaName = arena[ArenaKeys.Name] as? String else{
            completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: arenaName")
            return player
        }
        
        if let leagueStatistics = response?[ClashRoyaleResponseKeys.LeagueStatistics] as? [String:AnyObject]{
            guard let currentSeason = leagueStatistics[LeagueStatisticsKeys.CurrentSeason] as? [String:AnyObject] else{
                completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: currentSeason")
                return player
            }
            
            guard let bestSeason = leagueStatistics[LeagueStatisticsKeys.BestSeason] as? [String:AnyObject] else{
                completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: bestSeason")
                return player
            }
            
            guard let currentSeasonTrophies = currentSeason[SeasonKeys.Trophies] as? Int64 else{
                completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: : currenSeasonBest")
                return player
            }
            
            guard let bestSeasonBestTrophies = bestSeason[SeasonKeys.Trophies] as? Int64 else{
                completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: bestSeasonBest")
                return player
            }
            
            player.trophies = currentSeasonTrophies
            player.bestSeasonTrophies = bestSeasonBestTrophies
        }else{
            guard let trophies = response?[SeasonKeys.Trophies] as? Int64 else{
                completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: trophies")
                return player
            }
            
            guard let bestTrophies = response?[SeasonKeys.BestTrophies] as? Int64 else{
                completionHandlerForCreatePlayer(false,"Error occured and cannot fetch player: bestTrophies")
                return player
            }
            
            player.trophies = trophies
            player.bestSeasonTrophies = bestTrophies
            
        }
 
        dataController.viewContext.perform {
            player.tag = tag
            player.name = name
            player.expLevel = expLevel
            player.wins = wins
            player.losses = losses
            player.battleCount = battleCount
            player.threeCrownWins = threeCrownWins
            player.challengeCardsWon = challengeCardWon
            player.challengeMaxWins = challengeMaxWins
            player.tournamentCardWon = tournamentCardWon
            player.tournamentBattleCount = tournamentBattleCount
            player.totalDonations = totalDonations
            player.warDayWins = warDayWins
            player.clanCardsCollected = clanCardsCollected
            player.arenaName = arenaName
            player.totalDonations = totalDonations
            player.donations = donations
            player.donationsReceived = donationsReceived
            player.favouriteCard = favouriteCardName
            
            do{
                try dataController.viewContext.save()
            }catch{
                fatalError(error.localizedDescription)
            }
            
        }
        
        return player
    }
    
    //MARK:- createClan
    private func createClan(_ player: Player,_ clanTag: String ,_ completionHandlerForCreateClan:@escaping(_ success: Bool, _ error: String?) -> Void, _ dataController: DataController){
        
        let _ = taskForGetMethod(substituteKeyInMethod(Methods.Clans, key: "tag", value: clanTag)!){(response, error) in
            
            if let error = error{
                completionHandlerForCreateClan(false, error.userInfo[NSLocalizedDescriptionKey] as? String)
            }else{
                guard let tag = response?[ClanKeys.Tag] as? String else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: tag")
                    return
                }
                
                guard let name = response?[ClanKeys.Name] as? String else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: name")
                    return
                }
                
                guard let clanScore = response?[ClanKeys.ClanScore] as? Int64 else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan clanScore")
                    return
                }
                
                guard let clanWarTrophies = response?[ClanKeys.ClanWarTrophies] as? Int64 else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: clanWarTrophies")
                    return
                }
                
                guard let requiredTrophies = response?[ClanKeys.RequiredTrophies] as? Int64 else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: requiredTrophies")
                    return
                }
                
                guard let donationsPerWeek = response?[ClanKeys.DonationsPerWeek] as? Int64 else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: donationsPerWeek")
                    return
                }
                
                guard let location = response?[ClanKeys.Location] as? [String:AnyObject] else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: location")
                    return
                }
                
                guard let locationName = location[ClanLocationKeys.Name] as? String else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: locationName")
                    return
                }
                
                guard let type = response?[ClanKeys.ClanType] as? String else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: type")
                    return
                }
                
                guard let clanDescription = response?[ClanKeys.Description] as? String else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: clanDescription")
                    return
                }
                
                guard let members = response?[ClanKeys.Members] as? Int64 else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: members")
                    return
                }
                
                guard let badgeId = response?[ClanKeys.BadgeID] as? Int64 else{
                    completionHandlerForCreateClan(false,"Error occured and cannot fetch clan: badge")
                    return
                }
                
                dataController.viewContext.perform {
                    let clan = Clan(context: dataController.viewContext)
                    
                    clan.name = name
                    clan.type = type
                    clan.tag = tag
                    clan.requiredTrophies = requiredTrophies
                    clan.clanScore = clanScore
                    clan.clanDescription = clanDescription
                    clan.clanWarTrophies = clanWarTrophies
                    clan.members = members
                    clan.location = locationName
                    clan.donationPerWeek = donationsPerWeek
                    clan.badge = String(badgeId)
                    
                    player.clan = clan
                    
                    do{
                        try dataController.viewContext.save()
                    }catch{
                        fatalError(error.localizedDescription)
                    }
                }
                self.loadUpcomingChests(player, player.tag!, completionHandlerForCreateClan, dataController)
                
            }
        }
    }
    
    //MARK:- loadUpcomingChests
    private func loadUpcomingChests(_ player: Player,_ tag: String ,_ completionHandlerLoadUpcomingChests:@escaping(_ success: Bool, _ error: String?) -> Void, _ dataController: DataController){
        
        let _ = taskForGetMethod(substituteKeyInMethod(Methods.UpcomingChests, key: "tag", value: tag)!){(response, error) in
            
            if let error = error{
                completionHandlerLoadUpcomingChests(false, error.userInfo[NSLocalizedDescriptionKey] as? String)
            }else{
                
                guard let items = response?[ChestsResopnseKeys.Items] as? [[String:AnyObject]] else{
                    completionHandlerLoadUpcomingChests(false,"Error occured and cannot fetch chests")
                    return
                }
                
                for chest in items{
                    guard let name = chest[ChestsResopnseKeys.Name] as? String else{
                        completionHandlerLoadUpcomingChests(false,"Error occured and cannot fetch chests")
                        return
                    }
                    guard let index = chest[ChestsResopnseKeys.index] as? Int64 else{
                        completionHandlerLoadUpcomingChests(false,"Error occured and cannot fetch chests")
                        return
                    }
                    
                    dataController.viewContext.perform {
                        let chest = Chest(context: dataController.viewContext)
                        
                        chest.name = name
                        chest.index = index
                        
                        player.addToChests(chest)
                        
                        do{
                            try dataController.viewContext.save()
                        }catch{
                            fatalError(error.localizedDescription)
                        }
                    }
                }
                completionHandlerLoadUpcomingChests(true,nil)
            }
        }
    }
}

