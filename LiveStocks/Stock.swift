//
//  Stock.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

class Stock {
    // Class/Object is unnecessary right now, unable to add price
    var symbol : String
    var name: String
    var currency: String
    
    init(symbol: String) {
        self.symbol = symbol
        self.name = ""
        self.currency = ""
    }
    
    init(symbol: String, name: String, currency: String) {
        self.symbol = symbol
        self.name = name
        self.currency = currency
    }
    
    // Async call to get quote - can only be used whenever price display is needed immediately
    static func getQuote(symbol: String, completion: @escaping (Double) -> Void) {
        // API call
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote/latestPrice?token=pk_a85004ad0796453fb7110fad20e2a34a")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let quote = try Double(String(data: data, encoding: .utf8)!) else { return }
                    DispatchQueue.main.async {
                        completion(quote)
                    }
                } catch {
                    print("Error retrieving quote from IEX Cloud...")
                }
            }
        }.resume()
    }
}
