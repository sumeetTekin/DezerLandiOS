//
//  OptionVC.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 19/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

@objc protocol OptionVCDelegate {
    func editprofile()
    func customerSupportAction()
    func signOut()
    func roomTemprature()
    func orderHistory()
    func lock()
}


class OptionVC: UIViewController {
    weak var delegate : OptionVCDelegate?
    @IBOutlet weak var btn_editProfile: UIButton!
    @IBOutlet weak var btn_signOut: UIButton!
    @IBOutlet weak var btn_support: UIButton!
    @IBOutlet weak var btn_roomTemprature: UIButton!
    @IBOutlet weak var btn_orderHistory: UIButton!
    @IBOutlet weak var btn_lock: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.logScreen(screenName: "Logout Menu screen", className: "OptionVC")

        btn_support.setTitle(BUTTON_TITLE.Customer_support, for: .normal)
        // Do any additional setup after loading the view.
        btn_editProfile.titleLabel?.adjustsFontSizeToFitWidth = true
        btn_editProfile.titleLabel?.lineBreakMode = .byClipping
        
        btn_signOut.titleLabel?.adjustsFontSizeToFitWidth = true
        btn_signOut.titleLabel?.lineBreakMode = .byClipping
        
        btn_roomTemprature.titleLabel?.adjustsFontSizeToFitWidth = true
        btn_roomTemprature.titleLabel?.lineBreakMode = .byClipping
        btn_roomTemprature.setTitle(BUTTON_TITLE.paymentHistory, for: .normal)
        btn_orderHistory.setTitle(BUTTON_TITLE.Order_History, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.editprofile()
        }
    }
    @IBAction func signoutAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.signOut()
        }
    }
    @IBAction func supportAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.customerSupportAction()
        }
    }
    @IBAction func roomTemprature(_ sender : UIButton){
        self.dismiss(animated: true) {
            self.delegate?.roomTemprature()
        }
    }
    @IBAction func orderHistory(_ sender: Any){
        self.dismiss(animated: true) {
            self.delegate?.orderHistory()
        }
    }
    @IBAction func lockAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.lock()
            UserDefaults.standard.set(true, forKey: "isLockButtonPresed")
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
         self.dismiss(animated: true) {
        }
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
