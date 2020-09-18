//
//  MyTextField.swift
//  MyPortfolio
//
//  Created by jasvinders.singh on 8/30/17.
//  Copyright © 2017 Good Grid. All rights reserved.
//

import UIKit

class MyTextField: UITextField {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        if self.leftView == nil {
            let leftPaddingView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.size.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always
        }
        
    }
    func set(leftView : UIView?){
        self.leftView = leftView
        self.leftViewMode = .always
        if self.leftView == nil {
                self.leftViewMode = .never
        }
    }
    func requiredField(){
        let starImage = UIImageView(image: #imageLiteral(resourceName: "img_red_star"))
        starImage.frame = CGRect(x: 2, y: 2, width: 9, height: 9)
        self.addSubview(starImage)
    }

}
