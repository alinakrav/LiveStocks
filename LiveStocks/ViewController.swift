//
//  ViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-27.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let model = StockModel()
    var stockArr = [Stock]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        stockArr = model.getStocks()
        // print(stockArr[0].name, stockArr[1].name)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableViewCell
        
        // TODO: configure
        cell.configureCell(stock: stockArr[indexPath.row])
        return cell
    }

}

