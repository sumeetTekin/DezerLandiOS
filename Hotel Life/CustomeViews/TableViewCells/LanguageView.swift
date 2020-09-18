//
//  LanguageView.swift
//  Hotel Life
//
//  Created by Vikas Mehay on 13/12/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class LanguageView: UIView {
    var languageObject : Language?
    
    var img_flag : UIImageView = UIImageView()
    var lbl_title : UILabel = UILabel()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init(language : Language?, frame : CGRect) {
        super.init(frame: frame)
        self.languageObject = language
        img_flag = UIImageView(frame: CGRect(x:10, y: frame.height/4, width : frame.height/2 + 5, height : frame.height/2))
        img_flag.image = languageObject?.image
        self.addSubview(img_flag)
        
        lbl_title = UILabel(frame: CGRect(x: img_flag.frame.maxX, y: 0, width: frame.width - img_flag.frame.maxX, height: frame.height))
        lbl_title.textAlignment = .center
        lbl_title.text = languageObject?.languageTitle
        self.addSubview(lbl_title)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
