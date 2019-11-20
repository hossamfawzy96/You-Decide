//
//  PlayerTagViewController.swift
//  Capstone App
//
//  Created by Hossameldien Hamada on 11/2/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import CoreData

//MARK:- PlayerTagViewController
class PlayerTagViewController: UIViewController {
    
    //MARK:- Properties
    private var dataController: DataController!
    private var autoLogout: Bool!
    private var spinner: SpinnerViewController!
    
    //MARK:- Otlets
    @IBOutlet weak var playerTag: UITextField!
    @IBOutlet weak var search: UIButton!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogout = (UIApplication.shared.delegate as! AppDelegate).autoLogout!
        dataController = DataControllerSingelton.sharedDataControllerInstance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let players = fetchPlayerCoreData()
        
        // if the autoLogout option is false then the player info is fetched
        // from the coreData
        if(!autoLogout){
            if(players.count > 0){
                presentProfile()
            }
        }else{ // make sure that there exist only one player info in the core data
            if(players.count > 0){
                dataController.viewContext.delete(players[0])
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func search(_ sender: Any) {
        checkInput {
            self.spinner = SpinnerViewController()
            self.spinner.createSpinnerView(parent: self)
            self.updateUI(enabled: false)
            
            self.fetchPlayerAPI(playerTag: self.playerTag.text!)}
        
    }
    
    //MARK:- Private Functions
    private func fetchPlayerCoreData() -> [Player]{
        let playerFetchrequest: NSFetchRequest<Player> = Player.fetchRequest()
        if let result = try? self.dataController.viewContext.fetch(playerFetchrequest){
            return result
        }else{
            return []
        }
    }
    
    private func fetchPlayerAPI(playerTag: String){
        ClashRoyaleClient.sharedInstance().loadInfo(dataController: dataController, playerTag: playerTag){(success,error) in
            
            DispatchQueue.main.async {
                self.updateUI(enabled: true)
                self.spinner.removeSpinnerView()
                if(success){
                    self.presentProfile()
                }else{
                    self.searchFailed(message: error!)
                }
            }
            
        }
    }
    
    private func updateUI(enabled: Bool){
        playerTag.isEnabled = enabled
        search.isEnabled = enabled
    }
    
    private func searchFailed(message: String){
        AlertViewController().showError(title: "Search Failed",message: message, parent: self)
    }
    
    private func checkInput(completionHandlerForCheckInput: @escaping() -> Void){
        
        // guard for player tag checking
        guard (playerTag.text! != "") else{
            AlertViewController().showError(title: "Missing Credentials", message: "Please enter you player tag; ex:#GF3U3YND", parent: self)
            return
        }
        completionHandlerForCheckInput()
    }
    
    private func presentProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbedViewController = storyboard.instantiateViewController(identifier: "tabbedView")
        tabbedViewController.modalPresentationStyle = .fullScreen
        self.present(tabbedViewController, animated: false, completion: nil)
        
    }
    
}
