//
//  AddButtonTableViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-26.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class AddButtonTableViewController: UITableViewController {

  var stocks = [Stock](), filteredStocks = [Stock]()
  let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        loadStocks()
        
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
        Stock(symbol:"FOX"),
        Stock(symbol:"CRON.TO")
      ]
    }
    
    func fillStockCell(cell: UITableViewCell, stock: Stock) {
        cell.textLabel!.text = stock.symbol
        cell.detailTextLabel!.text = "quote"
//        Stock.getQuote(symbol: stock.symbol) { quote in
//            cell.detailTextLabel!.text = "\(quote)"
//        }
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
    filteredStocks = stocks.filter({( stock : Stock) -> Bool in
      return stock.symbol.lowercased().contains(searchText.lowercased())
    })
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddStockCell", for: indexPath)
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

extension AddButtonTableViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar) {
    filterContentForSearchText(searchBar.text!)
  }
}

extension AddButtonTableViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
