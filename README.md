# You-Decide
The sixth portfolio app in Udacity's IOS Nanodegree. The app is a helper for the well known game Clash Royale. The app supplies players with review profile options, stats and upcoming chests.
# Features List:
- Profile: Keeps track of all progress in the game. Players can review their stats, clan war stats, tournament stats, challenge stats, favourite card and current deck.
- Clan: shows the player's current clan's details.
- Cards: shows the player's current available set of cards.
- Card details: shows specific card's details on selection.
- Settings: Allows the Players to enable or disable autoLogout.
# How to use:
1. The user should write his player's tag from Clash Royale in the first Page. Usually the Player's tag is in the following format:"#D7T8VS0L".
2. After that the app will show a tabbed view with four options: Profile, Clan, Cards and Settings. the initial view of the tabbed view is the Player's Profile.
3. In the Profile view the user can scroll vertically to review his stats. The user Can tap any card's image to open the Card details view related to this card. Moreover, the user can scroll the upcoming chests horizontally to view all his upcoming chests. The user can choose to logout or refresh from the top tool bar.
4. The user can switch to any of the other three views just by tapping their icons in the tab bar.
5. In the Cards view the user can scroll vertically to view his current collection of cards and by tapping any card's image the respective Card details view will open to show the card's details.
6. In the Settings view the user can toggle the autologout mode. autologout mode is on by default so every time the user opens the app will have to re-enter his player's tag. If the user set the autologout mode off then the app will not ask him to enter his player's tag unless the user logouts from the profile view.
7. When the Card details view is presented the user can dismiss it by just swipping down the screen.
# How to run:
1. open Model > Clients > Clash Royale > Constants.swift
2. In ClashRoyale Struct replace the APIKey = "KEY" with your API Key.
3. API Key can be created on https://developer.clashroyale.com/#/login
