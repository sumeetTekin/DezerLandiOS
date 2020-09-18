//
//  PaymentDetailCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 19/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

class PaymentDetailCell: UITableViewCell {
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_roomNumber: UILabel!
    @IBOutlet weak var lbl_arrival: UILabel!
    @IBOutlet weak var lbl_departure: UILabel!
    @IBOutlet weak var lbl_invoiceDate: UILabel!
    @IBOutlet weak var lbl_invoiceNumber: UILabel!
    @IBOutlet weak var lbl_transactionAmount: UILabel!
    @IBOutlet weak var lbl_cardNumber: UILabel!
    
    var detail : PaymentDetail? {
        didSet {
            updateCell()
        }
    }
    var invoice : Invoice? {
        didSet {
            updateCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if viewBg != nil {
            viewBg.backgroundColor = .clear
            viewBg.addBorder(color: .white)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell() {
        if let name = detail?.name {
            lbl_name.text = "Name: \(name)"
        }
        else {
            lbl_name.text = "Name:"
        }

        if let ref = detail?.roomNumber {
            lbl_roomNumber.text = "Room No: \(ref)"
        }
        else {
            lbl_roomNumber.text = "Room No:"
        }
        if let dt = detail?.arrival {
            lbl_arrival.text = "Arrival: \(dt)"
        }
        else {
            lbl_arrival.text = "Arrival:"
        }
        if let dt = detail?.departure {
            lbl_departure.text = "Departure: \(dt)"
        }
        else {
            lbl_departure.text = "Departure:"
        }
        
        if let dt = detail?.invoiceNumber {
            lbl_invoiceNumber.text = "Invoice number: \(dt)"
        }
        else {
            lbl_invoiceNumber.text = "Invoice number:"
        }
        if let dt = detail?.invoiceDate {
            lbl_invoiceDate.text = "Invoice Date: \(dt)"
        }
        else {
            lbl_invoiceDate.text = "Invoice Date:"
        }
        if let dt = detail?.transactionAmount {
            lbl_transactionAmount.text = "\(dt)"
        }
        else {
            lbl_transactionAmount.text = ""
        }
        if let dt = detail?.cardnumber {
            lbl_cardNumber.text = "\(dt)"
        }
        else {
            lbl_cardNumber.text = ""
        }
    }

}
