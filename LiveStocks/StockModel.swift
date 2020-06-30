//
//  StockModel.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

class StockModel {
    let stockNames = ["AAPL", "VET"]
    
    func getStocks() -> [Stock] {
        var stockList = [Stock]()
        
        let stock1 = Stock(name: stockNames[0], cost: 350)
        let stock2 = Stock(name: stockNames[1], cost: 4.2)
        
        stockList += [stock1, stock2]
        // TODO: request data for elems
        
        // return stock data
        return stockList
    }
}
