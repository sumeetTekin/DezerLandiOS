//
//  AlohaMenuCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 30/03/18.
//  Copyright © 2018 jasvinders.singh. All rights reserved.
//

import UIKit
protocol AlohaMenuDelegate {
//    func alohaMenu()
}
class AlohaMenuCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_modifiers: UILabel!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lbl_orderStatus: UILabel!
    @IBOutlet weak var lbl_preprationTime: UILabel!
    @IBOutlet weak var lbl_orderTime: UILabel!
    @IBOutlet weak var lbl_deliveryTime: UILabel!
    @IBOutlet weak var constraint_heightModifiers: NSLayoutConstraint!
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
    func setupCellFor(alohaMenu : AlohaMenu, delegate : AlohaMenuDelegate) {
        lbl_title.text = alohaMenu.item_name != nil ? (alohaMenu.item_name)! : ""
        if alohaMenu.getModifiersName() == "" {
            lbl_modifiers.text = alohaMenu.getModifiersName()
        }
        else {
            lbl_modifiers.text = "\(alohaMenu.getModifiersName())"
        }
        lbl_desc.text = alohaMenu.getQuantityByPrice()
        lbl_price.text = "$\(alohaMenu.getTotalPrice())"
    }
    func setupStatusCellFor(alohaOrder : AlohaOrder) {
        if let text = alohaOrder.status {
            lbl_orderStatus.text = "\(TITLE.orderStatus) \(text)"
        }
        else {
            lbl_orderStatus.text = "\(TITLE.orderStatus)"
        }
        if let text = alohaOrder.prepTime {
            lbl_preprationTime.text = "\(TITLE.prepTime) \(text)"
        }
        else {
            lbl_preprationTime.text = "\(TITLE.prepTime)"
        }
        if let text = alohaOrder.orderTime {
            lbl_orderTime.text = "\(TITLE.orderTime) \(text)"
        }
        else {
            lbl_orderTime.text = "\(TITLE.orderTime)"
        }
        if let text = alohaOrder.promiseDateTime {
            lbl_deliveryTime.text = "\(TITLE.deliveryTime) \(text)"
        }
        else {
            lbl_deliveryTime.text = "\(TITLE.deliveryTime)"
        }
    }
    func setupTimeCellFor(alohaOrder : AlohaOrder) {
        
        if let text = alohaOrder.orderTime {
            lbl_orderTime.text = "\(TITLE.orderTime) \(text)"
        }
        else {
            lbl_orderTime.text = "\(TITLE.orderTime)"
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
