//
//  StockHoldingsViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-30.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class StockHoldingsViewController: UITableViewController {

    // This variable will hold the data being passed from the First View Controller
    var stock: Stock? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stock!.holdings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "holdingCell", for: indexPath)
        let holding : Holding
        //if no holdings then...
        // if has holdings then
        holding = stock!.holdings[indexPath.row]
        cell.textLabel!.text = "\(holding.shares) shares"
        cell.detailTextLabel!.text = "@ $" + String(format: "%.2f", holding.price)
        return cell
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        // limit method to specific segues
        guard identifier == "addHolding" || identifier == "editHolding" else { return }
        
        let addHoldingVC = segue.destination as! AddHoldingViewController
        addHoldingVC.stock = stock
        if identifier == "editHolding" {
            addHoldingVC.oldHolding = stock?.holdings[tableView.indexPathForSelectedRow!.row]
        }
    }
    
}

/*
extension StockHoldingsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("slide to dismiss stopped")
    }
} */
