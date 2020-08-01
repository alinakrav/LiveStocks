//
//  Holding.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-08-01.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

class Holding {
    var shares: Int
    var price: Float
    var commission: Float
    
    init(shares: Int, price: Float) {
        self.shares = shares
        self.price = price
        self.commission = 9.95
    }
}
