//
//  Stock.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

class Stock {
    var name : String
    var cost : Double
    
    init(name:String, cost:Double) {
        self.name = name
        self.cost = cost
    }
}
