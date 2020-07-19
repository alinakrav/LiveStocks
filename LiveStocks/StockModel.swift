//
//  StockModel.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

class StockModel {
    // replaced Stock object array with String array of just names, since I can't add price to objects anyway
    
    var stockList = [String]()
    
    func getStocks() -> [String] {
        // At the moment, stock array is made here

        stockList += ["AAPL", "IBM", "VET", "SPOT", "OXY"]
        
        // return stock data
        return stockList
    }
}
