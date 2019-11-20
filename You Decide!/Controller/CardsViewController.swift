//
//  CardsViewController.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import CoreData

//MARK:- CardsViewController
class CardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK:- Outlets
    @IBOutlet weak var Collection: UICollectionView!
    @IBOutlet weak var flow: UICollectionViewFlowLayout!
    
    //MARK:- Properties
    private var dataController: DataController!
    private var cards = [Card]()
    
    //MARK:- Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimensionWidth = (view.frame.size.width - (2*space))
        let dimensionHeight = (view.frame.size.height - (2*space)) 
        
        flow.minimumLineSpacing = space
        flow.minimumInteritemSpacing = space
        flow.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
        
        dataController = DataControllerSingelton.sharedDataControllerInstance
        
        let cardFetchrequest: NSFetchRequest<Card> = Card.fetchRequest()
        if let result = try? self.dataController.viewContext.fetch(cardFetchrequest){
            for card in result{
                cards.append(card)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        Collection.reloadData()
    }
}

//MARK:- CollectionView Functions
extension CardsViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = cards[indexPath.row]
        cardCollectionViewCell.cardIcon.image = UIImage(data: card.icon!)
        
        return cardCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let cardDetailsController = storyboard.instantiateViewController(withIdentifier: "cardDetails")as! CardDetailsViewController
        
        cardDetailsController.card = cards[indexPath.row]
        self.present(cardDetailsController, animated: true)
    }
}
