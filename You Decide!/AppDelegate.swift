//
//  AppDelegate.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var autoLogout: Bool?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let userAutoReload = UserDefaults.standard.value(forKey: "autoLogout"){
            autoLogout = userAutoReload as? Bool
        }else{
            UserDefaults.standard.set(true, forKey: "autoLogout")
            autoLogout = true
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if(autoLogout!){
            print("terminated")
            let  dataController = DataControllerSingelton.sharedDataControllerInstance
            let playerFetchrequest: NSFetchRequest<Player> = Player.fetchRequest()
            if let result = try? dataController.viewContext.fetch(playerFetchrequest){
                if(result.count > 0){
                    for player in result{
                        dataController.viewContext.delete(player)
                    }
                }
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return .portrait
    }
    
}

