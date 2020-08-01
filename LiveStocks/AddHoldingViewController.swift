//
//  AddHoldingViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-31.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class AddHoldingViewController: UIViewController {
    var stock: Stock? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(stock?.symbol)
    }
    

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let mainVC = segue.destination as! MainViewController
        // Pass the selected object to the new view controller.
        mainVC.stocks.append(Stock(symbol: "AddHoldingVC"))
        mainVC.tableView.reloadData()
    }

}
