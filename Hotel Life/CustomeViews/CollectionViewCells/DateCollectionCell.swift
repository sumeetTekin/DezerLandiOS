//
//  DateCollectionCell.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 29/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class DateCollectionCell: UICollectionViewCell {
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_month: UILabel!
   
    
    func configureDateCell(date : DateModel) {
        if !(date.date <= 0) {
            lbl_date.text = "\(date.date)"
            lbl_month.text = date.month
            
            if date.isSelected {
                self.lbl_month.isHidden = false
                lbl_month.textColor = UIColor.white
                lbl_date.textColor = UIColor.white
            }
            else{
                
                lbl_month.textColor = UIColor.lightGray
                self.lbl_month.isHidden = true
                lbl_month.text = date.month
                lbl_date.textColor = UIColor.lightGray
            }
        }
        else{
        lbl_date.text = ""
        lbl_month.text = ""
        
        if date.isSelected {
            self.lbl_month.isHidden = false
            lbl_month.textColor = UIColor.white
            lbl_date.textColor = UIColor.white
        }
        else{
            
            lbl_month.textColor = UIColor.lightGray
            self.lbl_month.isHidden = true
            lbl_month.text = ""
            lbl_date.textColor = UIColor.lightGray
        }
        }
    }
    
    func configureWeekDayCell(date : DateModel) {
        lbl_date.text = date.weekDay
        if date.isSelected {
            lbl_date.textColor = UIColor.white
        }
        else{
            lbl_date.textColor = UIColor.lightGray
        }
    }
    
}
