//
//  Constants.swift
//  Capstone App
//
//  Created by Hossameldien Hamada on 11/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation

extension ClashRoyaleClient{
    
    //MARK:- ClashRoyale
    struct ClashRoayle{
        static let APIScheme = "https"
        static let APIHost   = "api.clashroyale.com"
        static let APIPath   = "/v1"
        
        static let ApiKey = "KEY"
    }
    
    //MARK:- Methods
    struct Methods {
        static let Players = "/players/{tag}"
        static let UpcomingChests = "/players/{tag}/upcomingchests"
        static let Clans   = "/clans/{tag}"
    }
    
    
    //MARK:- ClashRoyale Messages Keys
    struct ClashRoyaleMessagesKeys{
        static let Reason = "reason"
        static let Messsage = "message"
        static let MessageType = "type"
        static let Detail = "detail"
    }
    //MARK:- ClashRoyale Response keys
    struct ClashRoyaleResponseKeys {
        static let Tag = "tag"
        static let Name = "name"
        static let EXPLevel = "expLevel"
        static let Trophies = "trophies"
        static let BestTrophies = "bestTrophies"
        static let Wins = "wins"
        static let Losses = "losses"
        static let BattleCount = "battleCount"
        static let ThreeCrownWins = "threeCrownWins"
        static let ChallengeCardsWon = "challengeCardsWon"
        static let ChallengeMaxWins = "challengeMaxWins"
        static let TournamentCardsWon = "tournamentCardsWon"
        static let TournamentBattleCount = "tournamentBattleCount"
        static let Donations = "donations"
        static let DonationsReceived = "donationsReceived"
        static let TotalDonations = "totalDonations"
        static let WarDayWins = "warDayWins"
        static let ClanCardsCollected = "clanCardsCollected"
        static let Arena = "arena"
        static let LeagueStatistics = "leagueStatistics"
        static let Cards = "cards"
        static let CurrentFavouriteCard = "currentFavouriteCard"
        static let currentDeck = "currentDeck"
        static let Clan = "clan"
        static let Role = "role"
        static let CurrenDeck = "currentDeck"
    }
    
    //MARK:- ArenaKeys
    struct ArenaKeys{
        static let ID = "id"
        static let Name = "name"
    }
    
    //MARK:- LeagueStatisticsKeys
    struct LeagueStatisticsKeys{
        static let CurrentSeason = "currentSeason"
        static let PreviousSeason = "previousSeason"
        static let BestSeason = "bestSeason"
    }
    
    //MARK:- SeasonKeys
    struct SeasonKeys{
        static let Trophies = "trophies"
        static let BestTrophies = "bestTrophies"
    }
    
    //MARK:- CardKeys
    struct CardKeys{
        static let Name = "name"
        static let ID = "id"
        static let Level = "level"
        static let MaxLevel = "maxLevel"
        static let Count = "count"
        static let IconURLs = "iconUrls"
    }
    
    //MARK:- IconURLsKeys
    struct IconURLsKeys {
        static let Medium = "medium"
    }
    
    //MARK:- ClanKeys
    struct ClanKeys{
        static let Tag = "tag"
        static let Name = "name"
        static let ClanWarTrophies = "clanWarTrophies"
        static let ClanScore = "clanScore"
        static let RequiredTrophies = "requiredTrophies"
        static let DonationsPerWeek = "donationsPerWeek"
        static let Location = "location"
        static let ClanType = "type"
        static let Members = "members"
        static let Description = "description"
        static let BadgeID = "badgeId"
        
    }
    
    //MARK:- ClanLocationKeys
    struct ClanLocationKeys{
        static let Name = "name"
    }
    
    //MARK:- ChestsResopnseKeys
    struct ChestsResopnseKeys{
        static let Items = "items"
        static let Name = "name"
        static let index = "index"
    }
}
