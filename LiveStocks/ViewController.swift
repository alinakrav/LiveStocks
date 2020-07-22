//
//  ViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    

    var searchController = UISearchController(searchResultsController: nil)
    var filteredStrings: [String] = []
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContentForSearchText(_ searchText: String) {
      filteredStrings = stockArr.filter { (string: String) -> Bool in
        return string.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }

    let model = StockModel()
    var stockArr = [String]()
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        stockArr = model.getStocks()
        tableView.dataSource = self
        tableView.delegate = self
//        searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
//        tableView!.setContentOffset(CGPoint(x:0, y:-227.5), animated: false)
    }
 */
    override func viewDidLoad() {
            super.viewDidLoad()
            stockArr = model.getStocks()
            tableView.dataSource = self
            tableView.delegate = self
            
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.obscuresBackgroundDuringPresentation = false
            navigationItem.hidesSearchBarWhenScrolling = true
            searchController.searchBar.placeholder = "Search Candies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "title"
        //                definesPresentationContext = true

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.searchController = searchController
    }
    
    
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
//            // it's going up
//        } else if self.lastContentOffset > scrollView.contentOffset.y && tableView.bounds.contains(tableView.rectForRow(at: IndexPath(row: 0, section: 0))) && (navigationController?.isNavigationBarHidden ?? false) {
//            navigationItem.searchController = nil
//            if navigationItem.searchController == nil {
//                navigationController?.isNavigationBarHidden = false
//                navigationItem.searchController = searchController
//            }
//        }
//    }
//
//    current best solution >>>>
//      func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//      if scrollView.contentOffset.y == 0 {
//        navigationItem.searchController = nil
//        if navigationController?.isNavigationBarHidden ?? false {
//            searchController.isActive = false
//            navigationItem.searchController = searchController
//            navigationController?.isNavigationBarHidden = false
//        }
//      }
//    }
        
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        print("top")
//        navigationItem.searchController = nil
//        if navigationItem.searchController == nil {
//            navigationController?.isNavigationBarHidden = false
//            navigationItem.searchController = searchController
//        }
//    }

//    func scrollViewScroll(_ scrollView: UIScrollView) {
//        if self.lastContentOffset > scrollView.contentOffset.y && tableView.bounds.contains(tableView.rectForRow(at: IndexPath(row: 0, section: 0))) && (navigationController?.isNavigationBarHidden ?? false) {
//            navigationItem.searchController = nil
//            if navigationItem.searchController == nil {
//                navigationController?.isNavigationBarHidden = false
//                navigationItem.searchController = searchController
//            }
//        }
//    }

    
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        performSegue(withIdentifier: "searchSegue", sender: self)
//    }
    
    // MARK: - table view delegate methods
    
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

