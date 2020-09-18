//
//  ALertView.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

@objc protocol AlertVCDelegate {
    func alertDismissed()
}

class AlertView: UIViewController {
    weak var delegate : AlertVCDelegate?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var img_alert: UIImageView!
    @IBOutlet weak var btn_done: UIButton!
    
    @IBOutlet weak var constraint_imageWidth: NSLayoutConstraint!
    @IBOutlet weak var constraint_imageHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        lbl_title.adjustsFontSizeToFitWidth = true
        lbl_title.lineBreakMode = .byClipping
        
        lbl_message.adjustsFontSizeToFitWidth = true
        lbl_message.lineBreakMode = .byClipping
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func contactUsAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.alertDismissed()
        }
    }
    
    func set(title : String , message : String, done_title : String ) {
            self.lbl_title.text = title
            if let attributedText = Helper.getHTMLAttributedString(text: message, alignment: .center) {
                self.lbl_message.attributedText = attributedText
            }
            else{
                self.lbl_message.text = message
            }
        
            self.btn_done.setTitle(done_title, for: .normal)
            self.btn_done.setTitleColor(UIColor.black, for: .normal)
            self.btn_done.backgroundColor = COLORS.THEME_YELLOW_COLOR
            constraint_imageWidth.constant = 100
            constraint_imageHeight.constant = 100
    }
    func showDescription(title : String , message : String, done_title : String ) {
        self.lbl_title.text = title
        self.lbl_message.text = message
        self.btn_done.setTitle(done_title, for: .normal)
        self.btn_done.setTitleColor(UIColor.black, for: .normal)
        self.btn_done.backgroundColor = COLORS.THEME_YELLOW_COLOR
        constraint_imageWidth.constant = 130
        constraint_imageHeight.constant = 130
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
