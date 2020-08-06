//
//  StockTableViewCell.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-08-03.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var sideQuote: UILabel!
}
