//
//  SubMenuCell.swift
//  BeachResorts
//
//  Created by Apple on 16/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class SubMenuCell: UITableViewCell {
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    @IBOutlet weak var lbl_description: UITextView!
    @IBOutlet weak var constraint_descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var view_disabledLayer: UIView!
    @IBOutlet weak var lbl_inactive: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if view_disabledLayer != nil {
            view_disabledLayer.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(indexPath: IndexPath, menuObj:Menu){
        childView.backgroundColor = .clear
        childView.layer.borderColor = UIColor.white.cgColor
        childView.layer.borderWidth = 1.0
        if let name = menuObj.label{
           titleLabel.text = name
        }else if let name = menuObj.labelName{
            titleLabel.text = name
        }
        titleLabel.isHidden = false
        self.view_disabledLayer.isHidden = menuObj.isEnabled
        lbl_inactive.text = menuObj.inactive_message
        DispatchQueue.main.async(execute: {
            self.cellImage.contentMode = .scaleToFill
            self.cellImage.sd_setImage(with: menuObj.imageURL, placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
            })
        })
    }
    func configureRestaurantCell(indexPath: IndexPath, menuObj:Menu){
        if let name = menuObj.label{
           titleLabel.text = name
        }else if let name = menuObj.labelName{
            titleLabel.text = name
        }
        
        
        titleLabel.isHidden = false
    }
    func configureLinkCell(indexPath: IndexPath, menuObj:Menu){
        childView.backgroundColor = .clear
        childView.layer.borderColor = UIColor.white.cgColor
        childView.layer.borderWidth = 1.0
        titleLabel.text = menuObj.label
        titleLabel.isHidden = false
        if self.view_disabledLayer != nil {
            self.view_disabledLayer.isHidden = menuObj.isEnabled
            lbl_inactive.text = menuObj.inactive_message
        }
        if let price = menuObj.item_price {
            if price == "" {
                lbl_subtitle.text = "$"+price
            }
            else{
                lbl_subtitle.text = ""
            }
            
        }
        
        if menuObj.itemType == .contact {
           constraint_descriptionHeight.constant = 0
        }
        else{
            if let desc = menuObj.linkDescription {
                if desc == "" {
                    constraint_descriptionHeight.constant = 0
                }
                else{
                    constraint_descriptionHeight.constant = 75
                    lbl_description.text = desc
                }
            }
            else{
                constraint_descriptionHeight.constant = 0
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.cellImage.contentMode = .scaleToFill
            self.cellImage.sd_setImage(with: menuObj.imageURL, placeholderImage: nil, options: [], progress: nil, completed: { (image, error, cacheType, url) in
            })
        })
    }

}
