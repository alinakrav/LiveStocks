//
//  StockTableViewCell.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-28.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cost: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(stock:Stock) {
        name.text = stock.name
        cost.text = "\(stock.cost)"
    }
}
