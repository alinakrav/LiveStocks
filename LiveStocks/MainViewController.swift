//
//  MainViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    // array for stocks saved to main table view
    var myStocks = [Stock]()
    var myStocksSymbols = [String]()
    // 2D array to hold stocks on main view and search view
    var stockSections = [[Stock]]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchTask: DispatchWorkItem?
    // space under main stock table to force searchbar to hide
    @IBOutlet weak var blankSpace: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        loadStocks()
        addSpaceToHideSearch()
    }

    // MARK: - Setup
    
    func loadStocks() {
        addStock(stock: Stock(symbol: "VET"))
        addStock(stock: Stock(symbol: "OXY"))

        // initialize stock array sections
        stockSections.append(myStocks)
        stockSections.append([Stock]())
    }
    
    // temp func to update myStocks - should be done in StockModel
    func addStock(stock: Stock) {
        myStocks.append(stock)
        myStocksSymbols.append(stock.symbol)
    }
    
    // adds extra space at bottom of table to enable search-hiding with few elements
    func addSpaceToHideSearch() {
        let tableFrame = tableView.frame.size.height
        let navHeight = (navigationController?.navigationBar.frame.size.height ?? 0) + (navigationController?.navigationBar.frame.origin.y ?? 0)
        let searchHeight = searchController.searchBar.frame.height
        // adjust for initial number of rows
        let cellHeight = CGFloat(44*myStocks.count)

        let height = tableFrame - navHeight - searchHeight - cellHeight + 5
        if height < 0 {
            blankSpace.frame.size.height = 0
        } else {
            blankSpace.frame.size.height = height
        }
    }
    
    // MARK: - Table view data
    
    // return number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return stockSections.count
    }
    
    // return rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockSections[section].count
    }
    
    // fill cells with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        // specify stock object to get data from
        let stock: Stock
        stock = stockSections[indexPath.section][indexPath.row]
        // fill cell with stock data
        fillStockCell(cell: cell, stock: stock)
        return cell
    }
    
    func fillStockCell(cell: UITableViewCell, stock: Stock) {
        cell.textLabel!.text = stock.symbol
        cell.detailTextLabel!.text = "quote"
        //        Stock.getQuote(symbol: stock.symbol) { quote in
        //            cell.detailTextLabel!.text = String(format: "%.2f", quote)
        //        }
    }
    
    // MARK: - Search
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    // update table with new stocks during search
    func updateTableWithSearchResults(_ searchText: String) {
        // when no text is entered, show only my stocks
        if searchBarIsEmpty() {
            stockSections[0] = myStocks
            stockSections[1] = [Stock]()
            tableView.reloadData()
        } else {
            // show my stocks in search
            stockSections[0] = myStocks.filter({( stock : Stock) -> Bool in
                let containsSymbol = stock.symbol.lowercased().contains(searchText.lowercased())
                let containsName = stock.name.lowercased().contains(searchText.lowercased())
                return containsSymbol || containsName
            })
            // show new stocks in search
            findStocks(keyword: searchText) { stocksFound in
                // filter out myStocks from stocksFound
                self.stockSections[1] = stocksFound.filter({( stock : Stock) -> Bool in
                    return !self.myStocksSymbols.contains(stock.symbol)
                })
                self.tableView.reloadData()
            }
        }
    }
    
    func findStocks(keyword: String, completion: @escaping ([Stock]) -> Void) {
        let keyword = String(keyword.map { $0 == " " ? "+" : $0 })
        let url = URL(string: "https://api.tiingo.com/tiingo/utilities/search?query=\(keyword)&token=728db149992e36b1d617774af5921ae43cf53fcc")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else { return }
                    // parse json data into array of stocks found
                    var stocksFound = [Stock]()
                    for stockData in json {
                        let stock = Stock(symbol: stockData["ticker"] as? String ?? "", name: stockData["name"] as? String ?? "", currency: stockData["countryCode"] as? String ?? "")
                        stocksFound.append(stock)
                    }
                    DispatchQueue.main.async {
                        completion(stocksFound)
                    }
                } catch { print("Error retrieving data from Tiingo...")}
            }
        }.resume()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Section header
    
    let sectionHeaderHeight = CGFloat(60)
    
    // section header image
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // make header for searched stocks, when section exists
        guard searchController.isActive && stockSections[section].count != 0 else {return nil}
        
        // draw header title
        let view = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 0))
        let label = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 6, width: tableView.frame.size.width, height: sectionHeaderHeight))
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        switch section {
        case 0:
            label.text = "Watchlist"
        case 1:
            label.text = "Symbols"
        default:
            label.text = "Stocks"
        }
        view.addSubview(label)
        
        // draw separator at top of Symbols header for Watchlist's last cell
        if section == 1 && stockSections[0].count != 0 {
            let topLine = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.size.width, height: 0.5))
            topLine.backgroundColor = tableView.separatorColor
            view.addSubview(topLine)
        }
        
        // draw separator for bottom of section header
        let bottomLine = UIView(frame: CGRect(x: 0, y: sectionHeaderHeight, width: tableView.frame.size.width, height: 0.5))
        bottomLine.backgroundColor = tableView.separatorColor
        view.addSubview(bottomLine)
        
        view.backgroundColor = UIColor.clear
        return view
    }
    
    // section header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // only make header for searched stocks, when section exists
        guard searchController.isActive && stockSections[section].count != 0 else {return 0}
        return sectionHeaderHeight
    }
    
    
    // MARK: - Navigation
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "viewHoldings", sender: self)
        } else {
            performSegue(withIdentifier: "addHoldingFromSearch", sender: self)
        }
    }
    
    // Called before cellTapped segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        guard identifier == "viewHoldings" || identifier == "addHoldingFromSearch" else {return}
        let indexPath = tableView.indexPathForSelectedRow
		let stock = stockSections[indexPath!.section][indexPath!.row]
        let navVC = (segue.destination as? UINavigationController)?.topViewController
        switch identifier {
        case "viewHoldings":
            // get a reference to the second view controller
            let viewHoldingsVC = navVC as! StockHoldingsViewController
            // pass tapped stock to next view
            viewHoldingsVC.stock = stock
        case "addHoldingFromSearch":
            let addHoldingVC = navVC as! AddHoldingViewController
            addHoldingVC.stock = stock
            addHoldingVC.newStock = true
        default:
            return
        }
    }
    
    // Called when other views exit back to main view
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue) {
        // exit search if new holding was saved
        guard sender.identifier == "saveHolding" else {return}
        searchController.isActive = false
		addSpaceToHideSearch()
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension MainViewController: UISearchResultsUpdating {
    
    // update table during search
    func updateSearchResults(for searchController: UISearchController) {
        // Cancel previous task if any
        searchTask?.cancel()
        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            self?.updateTableWithSearchResults(searchController.searchBar.text!)
        }
        searchTask = task
        // update table immediately if no input
        if searchBarIsEmpty() {
            DispatchQueue.main.async(execute: task)
            // delay table results when typing
        } else {
            // Execute task in 0.75 seconds (if not cancelled)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.40, execute: task)
        }
    }
}
