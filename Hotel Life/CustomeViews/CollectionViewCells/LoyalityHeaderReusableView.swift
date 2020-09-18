//
//  LoyalityHeaderReusableView.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/15/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import CircleProgressBar
protocol LoyaltyDelegate {
    func redeemAction()
}
class LoyalityHeaderReusableView: UICollectionReusableView {
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var redeemBtn: UIButton!
    @IBOutlet weak var progressBar: CircleProgressBar!
    @IBOutlet weak var lbl_balance: UILabel!
    var delegate : LoyaltyDelegate?
    
    func configureHeader(){
        childView.backgroundColor = .clear
        childView.layer.borderColor = UIColor.white.cgColor
        childView.layer.borderWidth = 1.0
        
        redeemBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        redeemBtn.titleLabel?.lineBreakMode = .byClipping
    }
    @IBAction func actionRedeem(_ sender: Any) {
        delegate?.redeemAction()
    }
    
}
