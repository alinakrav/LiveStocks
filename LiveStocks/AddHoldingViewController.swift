//
//  AddHoldingViewController.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-07-31.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

// Also used for editing a holding by inputting existing data into the view
class AddHoldingViewController: UITableViewController {
    var stock: Stock? = nil
    var newStock: Bool = false
    var oldHolding: Holding? = nil
    var defaultCommission: Float = -1.0
    var sharesData: Int = -1, priceData: Float = -1.0, commData: Float = -1.0
    
    @IBOutlet weak var shares: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var commission: UITextField!
    @IBOutlet weak var defaultBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide empty cell separators
        tableView.tableFooterView = UIView()
        
        // if no previous modal, replicate the back button
        if stock?.holdings.count == 0 {
            addBackButton(string: stock!.symbol)
        }
        
        enterData()
        defaultBtn.addTarget(self, action: #selector(checkBtn), for: .touchUpInside)
    }
    
    // sets commission value to default
    @objc func checkBtn() {
        // check/uncheck button
        defaultBtn.isSelected = !defaultBtn.isSelected
    }
    
    // MARK:- Setup
    
    // fill out fields with existing or default data
    func enterData() {
        // if holding is being edited, input existing data
        if oldHolding != nil {
            shares.text = String(oldHolding?.shares ?? -1)
            price.text = String(oldHolding?.price ?? -1.0)
            commission.text = oldHolding?.commission != 0 ? String(oldHolding?.commission ?? -1.0) : nil
            // select button if default commission is entered
            if defaultCommission == oldHolding?.commission  { defaultBtn.isSelected = true }
        }
            // set default commission value for new holding
        else {
            // enter default value if it exists (blank will already work as 0)
            commission.text = defaultCommission > 0 ? String(defaultCommission) : nil
            // select button when default commission is entered
            defaultBtn.isSelected = true
        }
    }
    
    func addBackButton(string: String) {
        // position of btn view on navbar
        let btnView = UIView(frame: CGRect(x:0, y:6, width: 58.5, height: 44))
        // position of label in btn view
        let label = UILabel(frame: CGRect(x: 24.5, y: 13, width: 200, height: 0))
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.textColor = .systemBlue
        label.text = string
        label.sizeToFit()
        btnView.addSubview(label)
        
        let icon = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23, weight: .medium))
        // convert UIImage to UIView
        let iconView = UIImageView(image: icon)
        // position of icon in btn view
        iconView.frame.origin.x = 5.5
        iconView.frame.origin.y = 12
        btnView.addSubview(iconView)
        
        // add button over view to perform action
        let clickableBtn = UIButton(type: .custom)
        clickableBtn.frame = CGRect(x:0, y:0, width: 58.5, height: 44)
        clickableBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        btnView.addSubview(clickableBtn)
        
        // add btnView to navbar as subview
        navigationController?.navigationBar.addSubview(btnView)
    }
    
    @objc func goBack() { dismiss(animated: true, completion: nil) }
    
    // MARK: - Navigation
    
    // Called when holding is saved
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveHolding" else {return}
        // if holding exists, change data
        if oldHolding != nil {
            oldHolding?.set(shares: sharesData, price: priceData, commission: commData)
        } else {
            // if no holding exists, create new one
            stock?.holdings.append(Holding(shares: sharesData, price: priceData, commission: commData))
        }
        // add stock from search to mainVC
        let mainVC = segue.destination as! MainViewController
        if newStock {
            mainVC.addStock(stock: stock!)
        }
        
        // set default commission based on new holding
        if defaultBtn.isSelected {
            mainVC.defaultCommission = commData
        } else {
            // remove default value
            mainVC.defaultCommission = -1.0
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
        let commString = commission.text!.replacingOccurrences(of: " ", with: "")
        // if string can be parsed into numbers, save data
        if let sharesInput = Int(sharesString), let priceInput = Float(priceString) {
            // blank commision means 0
            if commString == "" { commData = 0 }
            else if let commInput = Float(commString) { commData = commInput }
            sharesData = sharesInput
            priceData = priceInput
            return true
        }
        return false
    }
    
}
