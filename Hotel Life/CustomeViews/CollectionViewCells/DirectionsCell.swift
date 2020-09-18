//
//  DirectionsCell.swift
//  BeachResorts
//
//  Created by Apple on 16/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class DirectionsCell: UICollectionViewCell {
    @IBOutlet weak var xAxisLeftPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var xAxisRightPositionContraint: NSLayoutConstraint!
    @IBOutlet weak var yAxisTopPositionContraint: NSLayoutConstraint!
    @IBOutlet weak var yAxisBottomPositionContraint: NSLayoutConstraint!
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var cellDisabledlayer: UIView!
    
    
    func configureCell(indexPath: IndexPath, menuObj:Menu){
        yAxisTopPositionContraint.constant = 15
        yAxisBottomPositionContraint.constant = 0
        if indexPath.row % 2 == 0{
            xAxisLeftPositionConstraint.constant = 20
            xAxisRightPositionContraint.constant = 10
        }else{
            xAxisLeftPositionConstraint.constant = 10
            xAxisRightPositionContraint.constant = 20
        }
        childView.backgroundColor = .clear
        childView.layer.borderColor = UIColor.white.cgColor
        childView.layer.borderWidth = 1.0
        
        menuLabel.text = menuObj.label
        menuLabel.adjustsFontSizeToFitWidth = true
        menuLabel.lineBreakMode = .byClipping
        cellImageView.image = menuObj.cellImage
    }

}
