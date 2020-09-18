//
//  LoyalityCell.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/15/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import SDWebImage
class LoyalityCell: UICollectionViewCell {
    @IBOutlet weak var xAxisLeftPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var xAxisRightPositionContraint: NSLayoutConstraint!
    @IBOutlet weak var yAxisTopPositionContraint: NSLayoutConstraint!
    @IBOutlet weak var yAxisBottomPositionContraint: NSLayoutConstraint!
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var iconBackground: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var viewDisabled: UIView!
    
    func configureCell(indexPath: IndexPath, loyalityObj:Loyalty){
        
        childView.backgroundColor = .clear
        childView.layer.borderColor = UIColor.white.cgColor
        childView.layer.borderWidth = 1.0
        
        iconBackground.layer.cornerRadius = iconBackground.frame.size.width/2
        iconBackground.clipsToBounds = true
        
        titleLabel.text = loyalityObj.name
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byClipping
        if let points = loyalityObj.points {
            if points > 1 {
                subTitleLabel.text = "\(points) points"
            }
            else if points == 1 {
                subTitleLabel.text = "\(points) point"
            }
            else{
                subTitleLabel.text = ""
            }
        }
        subTitleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.lineBreakMode = .byClipping
        if let imageURL = loyalityObj.icon {
            icon.sd_setImage(with: imageURL, completed: nil)
        }
        
        self.viewDisabled.isHidden = !loyalityObj.is_enabled
       
    }
    
    
}
