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
    var searchTask: DispatchWorkItem?
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
//        cell.detailTextLabel!.text = "quote"
        Stock.getQuote(symbol: stock.symbol) { quote in
            cell.detailTextLabel!.text = String(format: "%.2f", quote)
        }
    }
    
    func testJson(keyword: String, completion: @escaping ([Stock]) -> Void) {
        let keyword = String(keyword.map { $0 == " " ? "+" : $0 })
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
    
    // MARK: - Standard search methods
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
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
        
        // when no text is entered, show normal stock array
        if searchBarIsEmpty() {
            filteredStocks = stocks
            tableView.reloadData()
        } else {
            testJson(keyword: searchText) { stockArr in
                self.filteredStocks = stockArr
                self.tableView.reloadData()
            }
        }
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
    
    // MARK: - Navigation
    
    // Called before cellTapped segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "cellTapped" else {return}
        // get a reference to the second view controller
        let navVC = segue.destination as? UINavigationController
        let stockHoldingsVC = navVC?.topViewController as! StockHoldingsViewController

        // pass cell stock to holdingsVC
        stockHoldingsVC.stock = stocks[tableView.indexPathForSelectedRow!.row]
    
    // delegate for swiping action
//        navVC?.presentationController?.delegate = cellTappedVC as! UIAdaptivePresentationControllerDelegate
    }
    
    // Called when other views exit back to main view
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue) {}
    
}


// MARK: - UISearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text!)
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Cancel previous task if any
        self.searchTask?.cancel()
        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            self?.filterContentForSearchText(searchController.searchBar.text!)
        }
        self.searchTask = task
        // Execute task in 0.75 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.40, execute: task)
    }
}
