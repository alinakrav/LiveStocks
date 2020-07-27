//
//  MainViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var stocks = [Stock](), filteredStocks = [Stock]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var blankSpace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        loadStocks()
        addSpaceToHideSearch()
    }
    
    // MARK: - Custom methods
    
    func loadStocks() {
        stocks = [
            Stock(symbol:"VET"),
            Stock(symbol:"OXY"),
            Stock(symbol:"SPOT"),
            Stock(symbol:"IBM"),
            Stock(symbol:"AAPL"),
            Stock(symbol:"NKLA"),
            Stock(symbol:"TSLA"),
            Stock(symbol:"MGI"),
            Stock(symbol:"FOX")
        ]
    }
    
    func fillStockCell(cell: UITableViewCell, stock: Stock) {
        cell.textLabel!.text = stock.symbol
        cell.detailTextLabel!.text = "quote"
//                Stock.getQuote(symbol: stock.symbol) { quote in
//                    cell.detailTextLabel!.text = "\(quote)"
//                }
    }
    
    func testJson(keyword: String, completion: @escaping ([Stock]) -> Void) {
        let url = URL(string: "https://api.tiingo.com/tiingo/utilities/search?query=\(keyword)&token=728db149992e36b1d617774af5921ae43cf53fcc")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else { return }
                    var stockArr = [Stock]()
                    for arrayElem in json {
                        let s = Stock(symbol: arrayElem["ticker"] as? String ?? "", name: arrayElem["name"] as? String ?? "", currency: arrayElem["countryCode"] as? String ?? "")
                        stockArr.append(s)
                    }
                    DispatchQueue.main.async {
                        completion(stockArr)
                    }
                } catch { print("Error retrieving data from Tiingo...")}
            }
        }.resume()
    }
    
    // adds extra space at bottom of table to enable search-hiding with few elements
    func addSpaceToHideSearch() {
        let height = 671-44*stocks.count
        if height < 0 {
            blankSpace.frame.size.height = 0
        } else {
            blankSpace.frame.size.height = CGFloat(height)
        }
    }
    
    // MARK: - Standard methods
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // update table with searched items
    func filterContentForSearchText(_ searchText: String) {
//            filteredStocks = stocks.filter({( stock : Stock) -> Bool in
//              return stock.symbol.lowercased().contains(searchText.lowercased())
//            })
//    tableView.reloadData()
        testJson(keyword: searchText) { stockArr in
            self.filteredStocks = stockArr
        }
        tableView.reloadData()
        
    }
    
    // is table being searched
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredStocks.count
        }
        return stocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        // specify stock object to get data from
        let stock: Stock
        if isFiltering() {
            stock = filteredStocks[indexPath.row]
        } else {
            stock = stocks[indexPath.row]
        }
        // fill cell with stock data
        fillStockCell(cell: cell, stock: stock)
        return cell
    }
    
}

extension MainViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension MainViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
