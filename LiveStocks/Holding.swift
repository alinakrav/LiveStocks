//
//  Holding.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-08-01.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

class Holding: Codable {
    var shares: Int
    var price: Float
    var commission: Float
    var gains: Float = 0
    
    init(shares: Int, price: Float, commission: Float) {
        self.shares = shares
        self.price = price
        self.commission = commission
    }
    
    func set(shares: Int, price: Float, commission: Float) {
        self.shares = shares
        self.price = price
        self.commission = commission
    }
}
