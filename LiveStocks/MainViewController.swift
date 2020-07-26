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
        Stock(name:"VET"),
        Stock(name:"OXY"),
        Stock(name:"SPOT"),
        Stock(name:"IBM"),
        Stock(name:"AAPL"),
        Stock(name:"NKLA"),
        Stock(name:"TSLA")
      ]
    }
    
    func fillStockCell(cell: UITableViewCell, stock: Stock) {
        cell.textLabel!.text = stock.name
        cell.detailTextLabel!.text = "quote"
//        Stock.getQuote(name: stock.name) { quote in
//            cell.detailTextLabel!.text = "\(quote)"
//        }
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
    filteredStocks = stocks.filter({( stock : Stock) -> Bool in
      return stock.name.lowercased().contains(searchText.lowercased())
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
