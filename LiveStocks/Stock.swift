//
//  Stock.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import Foundation

class Stock: Codable {
    // Class/Object is unnecessary right now, unable to add price
    var symbol : String
    var name: String
    var holdings = [Holding]()
    
    init(symbol: String, name: String) {
        self.symbol = symbol
        self.name = name
    }
    
    // Async call to get quote - can only be used whenever price display is needed immediately
    static func getQuote(symbol: String, completion: @escaping (Float?) -> Void) {
        // API call
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote/latestPrice?token=pk_a85004ad0796453fb7110fad20e2a34a")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                let quote = Float(String(data: data, encoding: .utf8)!)
                DispatchQueue.main.async {
                    completion(quote)
                }
            }
        }.resume()
    }
    
    // return array of 10- Stock objects containing keyword
    static func findStocks(keyword: String, completion: @escaping ([Stock]) -> Void) {
        let keyword = String(keyword.map { $0 == " " ? "+" : $0 })
        let url = URL(string: "https://api.tiingo.com/tiingo/utilities/search?query=\(keyword)&token=728db149992e36b1d617774af5921ae43cf53fcc")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] ?? [[String: String]]()
                    // parse json data into array of stocks found
                    var stocksFound = [Stock]()
                    for stockData in json {
                        let stock = Stock(symbol: stockData["ticker"] as? String ?? "", name: stockData["name"] as? String ?? "")
                        stocksFound.append(stock)
                    }
                    DispatchQueue.main.async {
                        completion(stocksFound)
                    }
                } catch { print("Error retrieving data from Tiingo...")}
            }
        }.resume()
    }
}
