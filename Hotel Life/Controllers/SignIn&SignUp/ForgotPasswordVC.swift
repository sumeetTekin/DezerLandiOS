//
//  ForgotPasswordVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
class ForgotPasswordVC: BaseViewController, AlertVCDelegate {
    
    @IBOutlet weak var txt_email: MyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Forgot Password screen", className: "ForgotPasswordVC")

        // Do any additional setup after loading the view.
        txt_email.placeholder = PLACEHOLDER.Email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        if validate() {
             self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            let loginUser:UserModel=UserModel()
            loginUser.email = txt_email.text
            AppInstance.applicationInstance.user = loginUser
            
            let bizObject:BusinessLayer=BusinessLayer()
            bizObject.forgotPassword({(status, message) in
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    if status {
                        let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
                        objAlert.delegate = self
                        self.definesPresentationContext = true
                        objAlert.modalPresentationStyle = .overCurrentContext
                        objAlert.modalTransitionStyle = .crossDissolve
                        objAlert.view.backgroundColor = .clear
                        self.present(objAlert, animated: true) {
                        }
                        
                    }else{
                        Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: message, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                        })
                    }
                })
            })
        }
    }
    
    func validate() -> Bool{
        if !(txt_email.text?.isValidEmail())! {
            Helper.showAlert(sender: self, title: ALERTSTRING.REQUIRED, message: ALERTSTRING.VALID_EMAIL)
            return false
        }
        else{
            return true
        }
    }
    
    func alertDismissed(){
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }

}
