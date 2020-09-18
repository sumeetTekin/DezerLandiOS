//
//  AlohaTaxCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 30/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit

class AlohaTaxCell: UITableViewCell {
    
    @IBOutlet weak var lbl_subTotal: UILabel!
    @IBOutlet weak var lbl_subTotalText: UILabel!
    @IBOutlet weak var lbl_serviceCharge: UILabel!
    @IBOutlet weak var lbl_serviceChargeText: UILabel!
    @IBOutlet weak var lbl_deliveryCharge: UILabel!
    @IBOutlet weak var lbl_deliveryChargeText: UILabel!
    @IBOutlet weak var lbl_stateTax: UILabel!
    @IBOutlet weak var lbl_stateTaxText: UILabel!
    @IBOutlet weak var lbl_Tax: UILabel!
    @IBOutlet weak var lbl_taxText: UILabel!
    @IBOutlet weak var lbl_countyTax: UILabel!
    @IBOutlet weak var lbl_countyTaxText: UILabel!
    @IBOutlet weak var lbl_totalDiscount: UILabel!
    @IBOutlet weak var lbl_totalDiscountText: UILabel!
    @IBOutlet weak var lbl_discountedSubtotalText: UILabel!
    @IBOutlet weak var lbl_discountedSubtotal: UILabel!
    @IBOutlet weak var constraint_subTotal: NSLayoutConstraint!
    @IBOutlet weak var constraint_discount: NSLayoutConstraint!
    @IBOutlet weak var constraint_discountedSubtotal: NSLayoutConstraint!
    @IBOutlet weak var constraint_serviceCharge: NSLayoutConstraint!
    @IBOutlet weak var constraint_delivery: NSLayoutConstraint!
    @IBOutlet weak var constraint_stateTax: NSLayoutConstraint!
    @IBOutlet weak var constraint_countyTax: NSLayoutConstraint!
    @IBOutlet weak var constraint_totalDiscount: NSLayoutConstraint!
    
    @IBOutlet weak var btn_promocode: UIButton!
    
    var reservationModel : ReservationModel?
    
    func setupTaxesLabels() {
        
    }
    
    func setupPromocodeLabel() {
        
        if let title = reservationModel?.taxPromoTotal?.promocodeText {
            if title != "" {
                btn_promocode.setTitle(title, for: .normal)
            }
            else{
                btn_promocode.setTitle("Apply Promocode", for: .normal)
            }
        }
        else{
            btn_promocode.setTitle("Apply Promocode", for: .normal)
        }
        
    }
    @IBAction func actionAddPromocode(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if lbl_subTotalText != nil {
            lbl_subTotalText.text = TITLE.subTotal
        }
        if lbl_totalDiscountText != nil {
            lbl_totalDiscountText.text = TITLE.totalDiscount
        }
        if lbl_discountedSubtotalText != nil {
            lbl_discountedSubtotalText.text = TITLE.subtotalAfterDiscount
        }
        if lbl_stateTaxText != nil {
            lbl_taxText.text = TITLE.statetax
        }
        if lbl_countyTax != nil {
            lbl_countyTax.text = "County Tax: "
        }
        if lbl_serviceChargeText != nil {
            lbl_serviceChargeText.text = TITLE.serviceCharge
        }
        if lbl_deliveryChargeText != nil {
            lbl_deliveryChargeText.text = TITLE.deliveryCharge
        }
        constraint_serviceCharge.constant = 0
        constraint_delivery.constant = 0
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
