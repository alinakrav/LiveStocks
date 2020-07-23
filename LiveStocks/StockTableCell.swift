//
//  StockTableViewCell.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-06-28.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

class StockTableCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(name: String) {
        self.name.text = name
        
        /*
        // Use handler from Stock function to display price (async call)
        Stock.getQuote(name: name) { (price) in
            self.price.text = "\(price)"
        }
 */
        
    }
}
