//
//  PaddedLabel.swift
//  LiveStocks
//
//  Created by Alina Kravchenko on 2020-08-08.
//  Copyright © 2020 LiveStocks. All rights reserved.
//

import UIKit

// Label subclass to make padding around text and round the corners
class PaddedLabel: UILabel {
    let topInset: CGFloat = 3
    let bottomInset: CGFloat = 3
    let leftInset: CGFloat = 5
    let rightInset: CGFloat = 5
    let cornerRadius: CGFloat = 5
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)))
        super.layer.cornerRadius = cornerRadius
        super.layer.masksToBounds = true
    }
    override var intrinsicContentSize: CGSize{
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}

// custom methods for label objects
extension UILabel {
    // add custom background color based on number's sign
    func colorCode(n: Float?) {
        if n == nil {
            // label font must be reset because cells are reused for search
            textColor = .label
            font = .systemFont(ofSize: 17)
            backgroundColor = nil
        } else if n! >= 0 {
            textColor = .white
            font = .systemFont(ofSize: 17, weight: .bold)
            // custom green
            backgroundColor = UIColor(red: 0.23, green: 0.79, blue: 0.44, alpha: 1)
        } else {
            textColor = .white
            font = .systemFont(ofSize: 17, weight: .bold)
            // custom red
            backgroundColor = UIColor(red: 0.84, green: 0.26, blue: 0.27, alpha: 1)
        }
    }
    
    // set label's text with delimiters, decimal places, and sign
    func format(n: Float?, sign: Bool, formatter: NumberFormatter) {
        let nStr = ( n == nil ? "" : formatter.string(from: NSNumber(value: n!)) )
        text = (sign && n! > 0 ? "+" : "") + nStr!
    }
}
