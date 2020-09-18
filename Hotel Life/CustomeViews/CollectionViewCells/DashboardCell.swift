//
//  DashboardCell.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/15/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class DashboardCell: UICollectionViewCell {
    @IBOutlet weak var xAxisLeftPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var xAxisRightPositionContraint: NSLayoutConstraint!
    @IBOutlet weak var yAxisTopPositionContraint: NSLayoutConstraint!
    @IBOutlet weak var yAxisBottomPositionContraint: NSLayoutConstraint!
    @IBOutlet weak var menuLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_inactive: UILabel!
    
    @IBOutlet weak var uberIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var uberIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lyftIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lyftIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shuttleIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var shuttleIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var taxiIconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var taxiIconHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var cellDisabledlayer: UIView!
    @IBOutlet weak var taxiImage: UIImageView!
    @IBOutlet weak var shuttleImage: UIImageView!
    @IBOutlet weak var lyftImage: UIImageView!
    @IBOutlet weak var uberImage: UIImageView!
    
    
    func configureCell(indexPath: IndexPath, menuObj:Menu, placeholderImage : UIImage?){
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
        childView.addBorder(color: .white)
        
        if menuObj.submoduleType == .directions{
            taxiImage.isHidden = false
            shuttleImage.isHidden = false
            lyftImage.isHidden = false
            uberImage.isHidden = false
            menuLabelBottomConstraint.constant = 38
        }else{
            taxiImage.isHidden = true
            shuttleImage.isHidden = true
            lyftImage.isHidden = true
            uberImage.isHidden = true
            menuLabelBottomConstraint.constant = 0
        }
        
        //self.iconSizeConstraintSetup()
        if !kAppDelegate.isUserCheckedIn{
            if indexPath.row == 0 || indexPath.row == 1{
                cellDisabledlayer.isHidden = true
            }else{
                cellDisabledlayer.isHidden = false
            }
        }else{
           cellDisabledlayer.isHidden = true
        }
        menuLabel.adjustsFontSizeToFitWidth = true
        menuLabel.lineBreakMode = .byClipping
        if let imageUrl = menuObj.imageURL {
            DispatchQueue.main.async(execute: {
                self.cellImageView.contentMode = .scaleToFill
                self.cellImageView.sd_setImage(with: imageUrl, placeholderImage: placeholderImage, options: [], progress: nil, completed: { (image, error, cacheType, url) in
                })
            })
        }
        else{
            if let image = menuObj.cellImage {
                self.cellImageView.image = image
            }
            
        }
        
        //Label Manipulation
        menuLabel.text = menuObj.label
        switch menuObj.submoduleType {
        case .directions:
//            if kAppDelegate.isUserCheckedIn {
//                //directions
//                menuObj.label = "Directions to Airport"
//            }
            menuLabel.text = menuObj.label
        case .checkout:
            if let checkin = AppInstance.applicationInstance.user?.check_in_sms, checkin == true {
                //CheckOut
                menuObj.label = TITLE.Mobile_Check_Out
            }
            menuLabel.text = menuObj.label
        default:
            break
        }
        cellDisabledlayer.isHidden = menuObj.isEnabled
        if lbl_inactive != nil {
            lbl_inactive.text = menuObj.inactive_message
        }
        
       
    }
    
    func iconSizeConstraintSetup(){
        uberIconWidthConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
        uberIconHeightConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
        
        lyftIconWidthConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
        lyftIconHeightConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
        
        shuttleIconWidthConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
        shuttleIconHeightConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
        
        taxiIconWidthConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
        taxiIconHeightConstraint.constant = (Device.SCREEN_WIDTH/2 * 0.15)
    }
}
