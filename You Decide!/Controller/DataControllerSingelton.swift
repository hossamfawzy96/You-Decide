//
//  DataControllerSingelton.swift
//  You Decide!
//
//  Created by Hossameldien Hamada on 11/10/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation

//MARK:- DataControllerSingelton
class DataControllerSingelton{
    static let sharedDataControllerInstance = DataController(modelName: "ClashRoyale")
}
