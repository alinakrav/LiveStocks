//
//  MainController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-22.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class MainController: UITableViewController, UISearchResultsUpdating {
        var searchController = UISearchController()
        var filteredStrings = [String](), tableData = [String]()


        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableData = StockModel().getStocks()

            searchController = ({
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.searchBar.sizeToFit()
                searchController.obscuresBackgroundDuringPresentation = false
//                navigationItem.title = "title"
                tableView.tableHeaderView = controller.searchBar
                tableView.contentOffset = CGPoint(x: 0, y: controller.searchBar.frame.size.height)
                return controller
            })()
            tableView.reloadData()
        }
 
        func updateSearchResults(for searchController: UISearchController) {
            filteredStrings.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
            let array = (tableData as NSArray).filtered(using: searchPredicate)
            filteredStrings = array as! [String]
            self.tableView.reloadData()
        }
        
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
                cell.configureCell(name: filteredStrings[indexPath.row])
            } else {
                cell.configureCell(name: tableData[indexPath.row])
            }
            return cell
        }
    
}


