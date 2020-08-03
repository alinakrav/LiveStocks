//
//  AddHoldingViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-31.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

// Also used for editing a holding by inputting existing data into the view
class AddHoldingViewController: UIViewController {
    var stock: Stock? = nil
    var newStock: Bool = false
    var oldHolding: Holding? = nil
    var sharesData: Int = -1, priceData: Float = -1.0
    
    @IBOutlet weak var shares: UITextField!
    @IBOutlet weak var price: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newStock {
            //         addBackButton()
            let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            navigationItem.leftBarButtonItem = backButton
        }
        
        
        // if holding is being edited, input existing data
        if oldHolding != nil {
            shares.text = String(oldHolding?.shares ?? -1)
            price.text = String(oldHolding?.price ?? -1.0)
        }
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UINavigationBar.appearance().backIndicatorImage, for: .normal)
        print(UINavigationBar.appearance())
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    @objc
    func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // Called when holding is saved
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveHolding" else {return}
        // if holding exists, change data
        if oldHolding != nil {
            oldHolding?.shares = sharesData
            oldHolding?.price = priceData
            // if no holding exists, create new one
        } else {
            stock?.holdings.append(Holding(shares: sharesData, price: priceData))
        }
        // add stock from search to tableview
        if newStock {
            let mainVC = segue.destination as! MainViewController
            mainVC.addStock(stock: stock!)
        }
    }
    
    // Disable saveHolding segue for invalid input
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "saveHolding" else {return true}
        // format commas, spaces
        var sharesString = shares.text!.replacingOccurrences(of: " ", with: "")
        sharesString = sharesString.replacingOccurrences(of: ",", with: "")
        var priceString = price.text!.replacingOccurrences(of: " ", with: "")
        priceString = priceString.replacingOccurrences(of: ",", with: "")
        // if string can be parsed into numbers, save data
        if let sharesInput = Int(sharesString), let priceInput = Float(priceString) {
            sharesData = sharesInput
            priceData = priceInput
            return true
        }
        return false
    }
    
}
