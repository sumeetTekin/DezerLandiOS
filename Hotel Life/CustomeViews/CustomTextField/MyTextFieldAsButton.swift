//
//  MyTextFieldAsButton.swift
//  MyPortfolio
//
//  Created by jasvinders.singh on 8/30/17.
//  Copyright © 2017 Good Grid. All rights reserved.
//

import UIKit

class MyTextFieldAsButton: UITextField {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        let leftPaddingView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
        let arrowImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
        arrowImage.image = #imageLiteral(resourceName: "dropDown")
        arrowImage.isUserInteractionEnabled = true
        arrowImage.contentMode = .scaleAspectFit
        rightPaddingView.addSubview(arrowImage)
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        
    }
    

}
