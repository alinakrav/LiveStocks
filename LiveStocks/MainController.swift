//
//  MainController.swift
//  test
//
//  Created by Alina Kravchenko on 2020-07-22.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class MainController: UITableViewController, UISearchResultsUpdating {
    var searchController = UISearchController(searchResultsController: nil)
        var filteredStrings = [String](), tableData = [String]()
//        var tableData = ["One","Two","Three","Twenty-One"]

        
    //    func updateSearchResults(for searchController: UISearchController) {
    //        let searchBar = searchController.searchBar
    //        filterContentForSearchText(searchBar.text!)
    //    }
        func updateSearchResults(for searchController: UISearchController) {
            filteredStrings.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
            let array = (tableData as NSArray).filtered(using: searchPredicate)
            filteredStrings = array as! [String]
            self.tableView.reloadData()
        }
        
    //
    //    var isSearchBarEmpty: Bool {
    //      return searchController.searchBar.text?.isEmpty ?? true
    //    }
    //    func filterContentForSearchText(_ searchText: String) {
    //      filteredStrings = tableData.filter { (string: String) -> Bool in
    //        return string.lowercased().contains(searchText.lowercased())
    //      }
    //      tableView.reloadData()
    //    }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
    //        tableView.delegate = self
            tableData = StockModel().getStocks()

            searchController = ({
                let searchController = UISearchController(searchResultsController: nil)
                searchController.searchResultsUpdater = self
                searchController.searchBar.sizeToFit()
                tableView.tableHeaderView = searchController.searchBar
                tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
                return searchController
            })()
            tableView.reloadData()
        }

    //    override func viewDidLoad() {
    //            super.viewDidLoad()
    //            stockArr = model.getStocks()
    //            tableView.dataSource = self
    //            tableView.delegate = self
    //
    //            searchController.searchResultsUpdater = self
    //            searchController.hidesNavigationBarDuringPresentation = true
    //            searchController.obscuresBackgroundDuringPresentation = false
    //            navigationItem.hidesSearchBarWhenScrolling = true
    //            searchController.searchBar.placeholder = "Search Candies"
    //        navigationController?.navigationBar.prefersLargeTitles = true
    //        navigationItem.title = "title"
    //        //                definesPresentationContext = true
    //
    //    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        navigationItem.searchController = searchController
    //    }
    //
        
        
        // MARK: - table view delegate methods
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // return number of rows
            if searchController.isActive {
                return filteredStrings.count
            } else {
                return tableData.count
            }
        }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableCell
            
            if searchController.isActive {
                cell.textLabel?.text = filteredStrings[indexPath.row]
            } else {
                cell.configureCell(name: tableData[indexPath.row])
            }
            return cell
        }

    }

