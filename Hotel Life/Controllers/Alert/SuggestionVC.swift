//
//  SuggestionVC.swift
//  Hotel Life
//
//  Created by jasvinders.singh on 10/25/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
@objc protocol SuggestionVCDelegate {
    func confirmAction(_obj:NotificationModel?)
    func newRequestAction(_obj:NotificationModel?)
}

class SuggestionVC: BaseViewController {
    var notificationObj : NotificationModel?
    weak var delegate : SuggestionVCDelegate?
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var newRequestBtn: UIButton!
    @IBOutlet weak var lbl_suggestion: UILabel!
    @IBOutlet weak var lbl_dateTime: UILabel!
    @IBOutlet weak var constraint_dialogHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraint_timeHeight: NSLayoutConstraint!
    var timeModification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbl_title.adjustsFontSizeToFitWidth = true
        lbl_title.lineBreakMode = .byClipping
        
        lbl_message.adjustsFontSizeToFitWidth = true
        lbl_message.lineBreakMode = .byClipping
        
        self.set(title: BUTTON_TITLE.Change_request, message: (notificationObj?.message?.suggestion_text)!)
        
        if let date = notificationObj?.message?.suggested_date {
            if let time = notificationObj?.message?.suggested_time {
                self.lbl_dateTime.text = "\(date) \(time)"
                self.lbl_suggestion.text = "Suggested Time:"
            }
            else{
                self.lbl_dateTime.text = "\(date)"
                self.lbl_suggestion.text = "Suggested Date:"
            }
        }
        if let modifyCompleteOrder = notificationObj?.message?.time_modify {
            
            timeModification = modifyCompleteOrder
            self.confirmBtn.setTitle(timeModification ?  TITLE.Confirm : "Yes", for: .normal)
            self.newRequestBtn.setTitle(timeModification ? TITLE.Modify : "No" , for: .normal)
            self.constraint_timeHeight.constant = timeModification ? 20 : 0
            self.constraint_dialogHeight.constant = timeModification ? 250 : 200
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func set(title : String , message : String) {
        
        self.lbl_title.text = title
        self.lbl_message.text = message
        
    }
    // Confirm action
    @IBAction func confirmAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.confirmAction(_obj: self.notificationObj)
        }
    }
    // Modify action
    @IBAction func newRequestAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.newRequestAction(_obj: self.notificationObj)
        }
    }
    
}
