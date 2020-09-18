//
//  TaxCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 21/11/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class TaxCell: UITableViewCell {

    @IBOutlet weak var lbl_subTotal: UILabel!
    @IBOutlet weak var lbl_subTotalText: UILabel!
    @IBOutlet weak var lbl_serviceCharge: UILabel!
    @IBOutlet weak var lbl_serviceChargeText: UILabel!
    @IBOutlet weak var lbl_deliveryCharge: UILabel!
    @IBOutlet weak var lbl_deliveryChargeText: UILabel!
    @IBOutlet weak var lbl_stateTax: UILabel!
    @IBOutlet weak var lbl_stateTaxText: UILabel!
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
        if let subTotal = reservationModel?.taxPromoTotal?.sub_total {
            constraint_subTotal.constant = subTotal > 0 ? 25 : 0
            lbl_subTotal.text = String.init(format: "$%.2f", subTotal)
        }
        
        if let serviceCharge = reservationModel?.taxPromoTotal?.service_charge_total{
           constraint_serviceCharge.constant = reservationModel?.tax?.service_charge != nil ? 25 : 0
//            constraint_serviceCharge.constant = serviceCharge == 0 ? 0 : 25
           lbl_serviceCharge.text = String.init(format: "$%.2f", serviceCharge)
        }
        
        if let deliveryCharge = reservationModel?.taxPromoTotal?.delivery_charge_total {
            constraint_delivery.constant = deliveryCharge > 0 ? 25 :0
            lbl_deliveryCharge.text = String.init(format: "$%.2f", deliveryCharge)
        }
        
        if let stateTax = reservationModel?.taxPromoTotal?.state_tax_total {
            constraint_stateTax.constant = reservationModel?.tax?.state_tax != nil ? 25 : 0
//            constraint_stateTax.constant = stateTax == 0 ? 0 : 25
            lbl_stateTax.text = String.init(format: "$%.2f", stateTax)
        }
        if let countyTax = reservationModel?.taxPromoTotal?.county_tax_total {
            constraint_countyTax.constant = reservationModel?.tax?.county_tax != nil ? 25 : 0
//            constraint_countyTax.constant = countyTax == 0 ? 0 : 25
            lbl_countyTax.text = String.init(format: "$%.2f", countyTax)
        }
        if let discount = reservationModel?.taxPromoTotal?.promocodeDiscount {
            constraint_totalDiscount.constant = discount > 0 ? 25 : 0
            lbl_totalDiscount.text = String.init(format: "- $%.2f", discount)
            if let discountSubtotal = reservationModel?.taxPromoTotal?.discounted_sub_total {
                constraint_discountedSubtotal.constant = discount > 0 ? 25 : 0
                lbl_discountedSubtotal.text = String.init(format: "$%.2f", discountSubtotal)
            }
        }
        
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
            lbl_stateTaxText.text = TITLE.tax
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
