//
//  InvoiceCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 23/02/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

class InvoiceCell: UITableViewCell {

    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lbl_dateTitle: UILabel!
    @IBOutlet weak var lbl_Reference: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    
    @IBOutlet weak var lbl_total: UILabel!
    
    var invoice : Invoice? {
        didSet {
            updateCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if view_bg != nil {
            view_bg.backgroundColor = .clear
            view_bg.addBorder(color: .white)
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell() {
        if let desc = invoice?.tdescrip {
            lbl_description.text = "Description: \(desc)"
        }
        else {
            lbl_description.text = "Description:"
        }
        if let ref = invoice?.tnum {
            lbl_Reference.text = "Reference: \(ref)"
        }
        else {
            lbl_Reference.text = "Reference:"
        }
        if let dt = invoice?.tdate {
                lbl_dateTitle.text = "Date: \(dt)"
        }
        else {
            lbl_dateTitle.text = "Date:"
        }
//        if let price = invoice?.tdebit {
//            lbl_debit.text = String(format: "$%.2f",Helper.getFloatVal(str: price))
//        }
//        if let price = invoice?.tcredit {
//            lbl_credit.text = String(format: "$%.2f",Helper.getFloatVal(str: price))
//        }
        lbl_total.text = getTotal()
    }
    func getTotal() -> String {
        var debit : Float = 0
        var credit : Float = 0
        if let debitVal = invoice?.tdebit {
                debit = Helper.getFloatVal(str: debitVal)
        }
        if let creditVal = invoice?.tcredit {
                credit = Helper.getFloatVal(str: creditVal)
        }
        return String(format: "%.2f",debit - credit)
    }
    

}
