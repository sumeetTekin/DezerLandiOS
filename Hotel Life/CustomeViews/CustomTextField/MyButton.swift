//
//  MyButton.swift
//  MyPortfolio
//
//  Created by jasvinders.singh on 8/30/17.
//  Copyright © 2017 Good Grid. All rights reserved.
//

import UIKit

class MyButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byClipping
    }
    
}
