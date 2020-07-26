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
    var name : String
    
    init(name:String) {
        self.name = name
    }
    
    // Async call to get quote - can only be used whenever price display is needed immediately
    static func getQuote(name: String, completion: @escaping (Double) -> Void) {
        // API call
        let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(name)&apikey=NYOTFMCNEXDFEB2D")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                    // limit is 5 calls/minute, 500 calls/day
                    guard let jsonQuote = try json["Global Quote"] as? [String: Any] else { return }
                    let quote = jsonQuote["05. price"] as? String
                    DispatchQueue.main.async {
                        completion(Double(quote!)!)
                    }
                } catch {
                    print("Error retrieving quote from Alpha Vantage...")
                }
            }
        }.resume()
    }
}
