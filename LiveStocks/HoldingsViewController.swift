//
//  HoldingsViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-30.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class HoldingsViewController: UITableViewController {

    var stock: Stock? = nil
    var newStock: Bool = false
    var numFormatter: NumberFormatter? = nil
    var deleted = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Title is stock's full name when view is shown
        navigationItem.title = stock?.name
    }

    // MARK: - Table view data

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stock!.holdings.count
    }

    // show holding data in cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "holdingCell", for: indexPath) as! HoldingCell
        // get holding for current cell index
        let holding = stock!.holdings[indexPath.row]
        
        cell.title.text = "\(holding.shares) @ $\(holding.price)"
        // format and display amount label
        cell.detail.format(n: holding.gains, sign: true, formatter: numFormatter!)
        cell.detail.colorCode(n: holding.gains)
        return cell
    }
    
    // delete cell on swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stock?.holdings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // will signal MainVC to update and save data
            deleted = true
            // dismiss if last holding deleted
            if tableView.numberOfRows(inSection: 0) == 0 {
                performSegue(withIdentifier: "done", sender: self)
            }
        }
    }
    
    // dragging modadl down goes to unwindToMain
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController!.isBeingDismissed {
            performSegue(withIdentifier: "done", sender: self)
        }
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        // limit method to specific segues
        guard identifier == "addHolding" || identifier == "editHolding" else { return }
        // Change title to symbol to show in "Back" button from next view
        navigationItem.title = stock?.symbol

        let addHoldingVC = segue.destination as! AddHoldingViewController
        addHoldingVC.stock = stock
        // tells AddHoldingVC if stock exists in mainVC table
        addHoldingVC.newStock = newStock
        if identifier == "editHolding" {
            addHoldingVC.oldHolding = stock?.holdings[tableView.indexPathForSelectedRow!.row]
        }
    }
    
}
