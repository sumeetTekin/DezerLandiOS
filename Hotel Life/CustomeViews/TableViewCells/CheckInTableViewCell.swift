//
//  CheckInTableViewCell.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/18/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class CheckInTableViewCell: UITableViewCell {
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var cellIconImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var lbl_expiry: UILabel!
    
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var checkInBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        if self.changeBtn != nil {
            self.changeBtn.isHidden = true
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(indexPath: IndexPath){
        childView.backgroundColor = .clear
        childView.addBorder(color: .white)
        switch indexPath.row {
        case 0:
           cellIconImage.image = #imageLiteral(resourceName: "img_card")
        case 1:
            cellIconImage.image = #imageLiteral(resourceName: "img_calendar_gray")
        case 2:
            break
        default:
            break
        }
    }

}
