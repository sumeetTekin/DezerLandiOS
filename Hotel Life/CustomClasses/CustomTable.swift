//
//  CustomTable.swift
//  TradeZero
//
//  Created by Amit Verma on 12/13/17.
//  Copyright © 2017 Amit Verma. All rights reserved.
//

import UIKit
@IBDesignable

class CustomTable: UITableView {

    @IBInspectable var corner_Radius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = corner_Radius
            layer.masksToBounds = corner_Radius > 0
        }
    }
    @IBInspectable var border_Width: CGFloat = 0 {
        didSet {
            layer.borderWidth = border_Width
        }
    }
    @IBInspectable var border_Color: UIColor? {
        didSet {
            layer.borderColor = border_Color?.cgColor
        }
    }

}
