//
//  SpinnerViewcontroller.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    //MARK:- LifeCycle
    override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = UIColor(white: 150, alpha: 0.3)
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK:- Functions
    func createSpinnerView(parent: UIViewController){
        parent.addChild(self)
        view.frame = parent.view.frame
        parent.view.addSubview(view)
        didMove(toParent: parent)
        
    }
    
    func removeSpinnerView(){
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    
}
