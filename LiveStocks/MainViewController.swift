//
//  MainViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    // NSDefaults to store data
    let defaults = UserDefaults.standard
    
    // STOCK DATA
    // default commission value (since it's usually constant)
    var defaultCommission: Float = 0
    // array for stocks saved to main table view
    var myStocks = [Stock]()
    var myStocksSymbols = [String]()
    // 2D array to hold stocks on main view and search view
    var allStocks = [[Stock]]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchTask: DispatchWorkItem?
    let numFormatter = NumberFormatter()
    // space under main stock table to force searchbar to hide
    @IBOutlet weak var blankSpace: UILabel!
    var searchOverlay = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        makeFormatter()
        setupSearchController()
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    // called at launch and after search, updates navbar total
    override func viewDidAppear(_ animated: Bool) {
        updateGainsWithDelay()
    }
    
    // MARK: - Setup
    
    func saveData() {
        do {
            try defaults.setObject(myStocks, forKey: "myStocks")
            defaults.set(myStocksSymbols, forKey: "myStocksSymbols")
            defaults.set(defaultCommission, forKey: "defaultCommission")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // formatter adds delimiters (commas) and limits decimal places
    func makeFormatter() {
        numFormatter.numberStyle = .decimal
        numFormatter.maximumFractionDigits = 2
        numFormatter.minimumFractionDigits = 2
    }
    
    // load stock array from NSDefaults
    func loadData() {
        do {
            myStocks = try defaults.getObject(forKey: "myStocks", castTo: [Stock].self)
            myStocksSymbols = defaults.stringArray(forKey: "myStocksSymbols") ?? [String]()
            defaultCommission = defaults.float(forKey: "defaultCommission")
        } catch {
            print(error.localizedDescription)
        }
        allStocks.append(myStocks)
        allStocks.append([Stock]())
    }
    
    // add new Stock object to myStocks (made to update array from AddHoldingVC)
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
        let cellHeight = CGFloat(56*myStocks.count)
        
        let height = tableFrame - navHeight - searchHeight - cellHeight + 5
        if height < 0 {
            blankSpace.frame.size.height = 0
        } else {
            blankSpace.frame.size.height = height
        }
    }
    
    // call updateGains method after a 1 sec delay
    func updateGainsWithDelay() {
        let task = DispatchWorkItem { [weak self] in
            self?.updateGains()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: task)
    }
    
    // calculate and display total holdings gain in navbar
    func updateGains() {
        var totalGains: Float = 0
        for stock in myStocks {
            var stockGains: Float = 0
            for holding in stock.holdings {
                stockGains += holding.gains
            }
            totalGains += stockGains
        }
        // format string
        navigationItem.title = (totalGains == 0 ? "" : (totalGains > 0 ? "+" : "-")) + " $" + numFormatter.string(from: NSNumber(value: abs(totalGains)))!
        // change text color based on amount
        let textAttributes: [NSAttributedString.Key : Any]
        if totalGains < 0 {
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 0.84, green: 0.26, blue: 0.27, alpha: 1)]
        } else {
            textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 0.23, green: 0.79, blue: 0.44, alpha: 1)]
        }
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    // update data in view when pulled down to refresh
    @objc func refresh(sender: Any)
    {
        self.tableView.reloadData()
        updateGains()
        let task = DispatchWorkItem { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
        // length of refresh animation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: task)
    }
    
    // MARK: - Table view data
    
    // return number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allStocks.count
    }
    
    // return rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStocks[section].count
    }
    
    // fill table with cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableViewCell
        // specify stock object to get data from
        let stock: Stock
        stock = allStocks[indexPath.section][indexPath.row]
        // fill cell with stock data
        fillStockCell(cell: cell, stock: stock, index: indexPath)
        return cell
    }
    
    // fill cell with data
    func fillStockCell(cell: StockTableViewCell, stock: Stock, index: IndexPath) {
        cell.symbol.text = stock.symbol
        cell.name.text = stock.name
        Stock.getQuote(symbol: stock.symbol) { quote in
            // clear numbers when quote unavailable (or label will be reused)
            guard quote != nil else {
                cell.amount.colorCode(n: nil)
                cell.amount.text = "Not Found"
                cell.sideQuote.text = nil
                return
            }
            
            // vars to hold nums for the 2 labels
            var amount: Float
            var sideQuote: Float? = nil
            
            // just show quote if no holdings
            if stock.holdings.count == 0 {
                cell.amount.colorCode(n: nil)
                amount = quote!
                // sideQuote stays nil
                
                // calculate gains if holdings exist
            } else {
                var gains: Float = 0
                // calculate gains
                for holding in stock.holdings {
                    let shares = Float(holding.shares)
                    holding.gains = quote!*shares - holding.price*shares - holding.commission
                    gains += holding.gains
                }
                // change amount colour
                cell.amount.colorCode(n: gains)
                amount = gains
                sideQuote = quote
            }
            // format and display gains and/or quote - detect gains label by checking if sideQuote exists
            cell.amount.format(n: amount, sign: sideQuote != nil, formatter: self.numFormatter)
            cell.sideQuote.format(n: sideQuote, sign: false, formatter: self.numFormatter)
        }
    }
    
    // enable editing (deleting) for Watchlist section
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 ? true : false
    }
    
    // delete cell on swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myStocks.remove(at: indexPath.row)
            myStocksSymbols.remove(at: indexPath.row)
            allStocks[0] = myStocks
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            updateGains()
            // store updated stock array
            saveData()
        }
    }
    
    // MARK: - Search
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        // show searchbar on launch
        tableView.setContentOffset(CGPoint(x: 0, y: -(searchController.searchBar.frame.height)), animated: false)
        // draw search overlay image
        searchOverlay.frame = view.frame
        searchOverlay.backgroundColor = .black
        tableView.addSubview(searchOverlay)
        searchOverlay.alpha = 0
        // cancel search when overlay is tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelSearch))
        searchOverlay.addGestureRecognizer(tap)
    }
    @objc func cancelSearch() { searchController.isActive = false }
    
    // fades in and out of tableview overlay
    func fadeOverlay(hidden: Bool) {
        let alpha: CGFloat = hidden ? 0 : 0.5
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
            self.searchOverlay.alpha = alpha
        })
        tableView.bringSubviewToFront(searchOverlay)
    }
    
    // update table with new stocks during search
    func updateTableWithSearchResults(_ searchText: String) {
        // when no text is entered, show only my stocks
        if searchBarIsEmpty() {
            // overlay screen when searchbar empty
            if !searchController.isActive {
                fadeOverlay(hidden: true)
            } else {
                fadeOverlay(hidden: false)
            }
            allStocks[0] = myStocks
            allStocks[1] = [Stock]()
            tableView.reloadData()
        } else {
            // show my stocks in search
            allStocks[0] = myStocks.filter({( stock : Stock) -> Bool in
                let containsSymbol = stock.symbol.lowercased().contains(searchText.lowercased())
                let containsName = stock.name.lowercased().contains(searchText.lowercased())
                return containsSymbol || containsName
            })
            // show new stocks in search
            Stock.findStocks(keyword: searchText) { stocksFound in
                // filter out myStocks from stocksFound
                self.allStocks[1] = stocksFound.filter({( stock : Stock) -> Bool in
                    // remove my stocks from new stocks, remove quoteless stocks
                    return !self.myStocksSymbols.contains(stock.symbol)
                })
                self.fadeOverlay(hidden: true)
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Section header
    
    let sectionHeaderHeight = CGFloat(60)
    
    // section header image
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // make header for searched stocks, when section exists
        guard !searchBarIsEmpty() && allStocks[section].count != 0 else {return nil}
        
        // draw header title
        let view = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 0))
        let label = UILabel(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.size.width, height: sectionHeaderHeight))
        label.font = .systemFont(ofSize: 32, weight: .bold)
        switch section {
        case 0:
            label.text = "Watchlist"
        case 1:
            label.text = "Symbols"
        default:
            label.text = ""
        }
        view.addSubview(label)
        
        view.backgroundColor = .clear
        return view
    }
    
    // section header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // only make header for searched stocks, when section exists
        guard !searchBarIsEmpty() && allStocks[section].count != 0 else {return 0}
        return sectionHeaderHeight
    }
    
    
    // MARK: - Navigation
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allStocks[indexPath.section][indexPath.row].holdings.count == 0 {
            performSegue(withIdentifier: "addHoldingFromSearch", sender: self)
        } else {
            performSegue(withIdentifier: "viewHoldings", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        let indexPath = tableView.indexPathForSelectedRow
        let stock = allStocks[indexPath!.section][indexPath!.row]
        let navVC = (segue.destination as? UINavigationController)?.topViewController
        switch identifier {
        case "viewHoldings":
            let nextVC = navVC as! HoldingsViewController
            nextVC.stock = stock
            nextVC.defaultCommission = defaultCommission
            nextVC.numFormatter = numFormatter
        case "addHoldingFromSearch":
            let nextVC = navVC as! AddHoldingViewController
            nextVC.stock = stock
            nextVC.defaultCommission = defaultCommission
            if indexPath?.section == 1 {
                nextVC.newStock = true
            }
        default:
            return
        }
    }
    
    // Called when other views exit back to main view
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {
        let identifier = sender.identifier
        guard identifier == "saveHolding" || identifier == "done" else {return}
        // update stocks when holdings are saved and deleted
        if sender.identifier == "saveHolding" {
            searchController.isActive = false
        }
        else if !(sender.source as! HoldingsViewController).deleted {
            return
        }
        tableView.reloadData()
        updateGainsWithDelay()
        saveData()
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
