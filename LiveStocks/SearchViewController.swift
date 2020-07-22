//
//  SearchViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-19.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate/*, UISearchControllerDelegate, UISearchResultsUpdating*/ {
    
    
    @IBOutlet weak var tableView: UITableView!
    let model = StockModel()
    var stockArr = [String]()


//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        filterContentForSearchText(searchBar.text!)
//    }
//    var isSearchBarEmpty: Bool {
//      return searchController.searchBar.text?.isEmpty ?? true
//    }
//    func filterContentForSearchText(_ searchText: String) {
//      filteredStrings = stockArr.filter { (string: String) -> Bool in
//        return string.lowercased().contains(searchText.lowercased())
//      }
//
//      tableView.reloadData()
//    }
//
//    var searchController : UISearchController!
//    var filteredStrings: [String] = []
//
    override func viewDidLoad() {
        super.viewDidLoad()
        stockArr = model.getStocks()
        
//        tableView.dataSource = self
//        tableView.delegate = self
        
//        let searchController = UISearchController(searchResultsController: nil)
//        // 1
//        searchController.searchResultsUpdater = self
//        // 2
//    searchController.obscuresBackgroundDuringPresentation = false
//        // 3
//        searchController.searchBar.placeholder = "Search Candies"
//        // 4
//        navigationItem.searchController = searchController
//        // 5
//        definesPresentationContext = true
//        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableViewCell
        
        // TODO: configure
        cell.configureCell(name: stockArr[indexPath.row])
        return cell
    }

}
