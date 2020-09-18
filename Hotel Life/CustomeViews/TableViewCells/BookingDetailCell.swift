//
//  BookingDetailCell.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/20/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
@objc protocol BookingDetailDelegate {
    @objc optional func removeItem(item : Menu)
}
class BookingDetailCell: UITableViewCell {
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_bg1: UIView!
    @IBOutlet weak var img_cellImage: UIImageView!
    @IBOutlet weak var lbl_OrderNumberText: UILabel!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_quantity_price: UILabel!
    @IBOutlet weak var reservationType: UILabel!
    @IBOutlet weak var reservationTotal: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var constraint_occasion: NSLayoutConstraint!
    @IBOutlet weak var constraint_specialRequest: NSLayoutConstraint!
    @IBOutlet weak var booking_status: UILabel!
    @IBOutlet weak var lbl_instructor: UILabel!
    
    @IBOutlet weak var lbl_duration: UILabel!
    var item : Menu?
    var delegate : BookingDetailDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if view_bg != nil {
            view_bg.backgroundColor = .clear
            view_bg.addBorder(color: .white)
        }
        if view_bg1 != nil {
            view_bg1.backgroundColor = .clear
            view_bg1.addBorder(color: .white)
        }
        if let identifier = self.reuseIdentifier {
            switch identifier {
            case CELL_IDENTIFIER.BOOKING_CANCEL :
                if view_bg != nil {
                    view_bg.addBorder(color: .clear)
                }
            case CELL_IDENTIFIER.BOOKING_ORDER_CHAIR :
                if lbl_title != nil {
                 self.lbl_title.text = TITLE.RoomNumber
                }
                if lbl_OrderNumberText != nil {
                    self.lbl_OrderNumberText.text = TITLE.OrderNumber
                }
            case CELL_IDENTIFIER.BOOKING_DATE:
                if lbl_title != nil {
                    self.lbl_title.text = TITLE.date
                }
            default:
                break
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellFor(item : Menu, delegate : BookingDetailDelegate?) {
        self.reservationType.text = item.item_name
        self.reservationTotal.text = "$\(String.init(format: "%.2f", item.getTotalPrice()))"
        self.lbl_quantity_price.text = "\(String.init(format: "%.0f", item.getTotalQuantity()))  X  $\(String.init(format: "%.2f", item.getItemPrice()))"
        
        if let identifier = self.reuseIdentifier {
            switch identifier {
            case CELL_IDENTIFIER.BOOKING_QUANTITY_DELETE:
                self.item = item
                self.delegate = delegate
            default:
                break
            }
        }        
        
    }
    @IBAction func actionRemove(_ sender: Any) {
        if let item = self.item {
            delegate?.removeItem!(item: item)
        }
    }
    
    
    
    
    
}
