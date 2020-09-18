//
//  LoginVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
class LoginVC: BaseViewController {

    @IBOutlet weak var txt_email: MyTextField!
    @IBOutlet weak var txt_password: MyTextField!
    @IBOutlet weak var btn_login: UIButton!
    
    var loginType : LoginType = .normal
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Login screen", className: "LoginVC")
        // Do any additional setup after loading the view.
        txt_email.placeholder = PLACEHOLDER.Email
        txt_password.placeholder = PLACEHOLDER.Password
        //AutoLogin Functionality
        if (UserDefaults.standard.object(forKey: USERDEFAULTKEYS.ALREADY_LOGIN) != nil) && (UserDefaults.standard.object(forKey: USERDEFAULTKEYS.ALREADY_LOGIN) as? Bool)!{
            if let user = Helper.ReadUserObject(){
                txt_email.text = user.email
                txt_password.text = user.password
                self.loginAction(self.btn_login)
            }
        }
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
    @IBAction func loginAction(_ sender: UIButton) {
        if validate() {
            self.login(self.txt_email.text!, password: self.txt_password.text!)
           
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Web-Service Calling
    func login(_ email:String,password:String) {
        
        //self.performSegue(withIdentifier: SEGUE_IDENTIFIER.DASHBOARDSEGUE, sender: nil)
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.SigningIn)

        }
        
        let loginUser:UserModel=UserModel()
        loginUser.email = email
        loginUser.password = password
        AppInstance.applicationInstance.user = loginUser
        let defaults = UserDefaults.standard
        defaults.setValue(password, forKey: USERDEFAULTKEYS.PASSWORD)
        defaults.synchronize()
        
        let bizObject:BusinessLayer=BusinessLayer()
        bizObject.loginNormal { (success, response) -> Void in
            
            DispatchQueue.main.async {
                //self.deactivateView(self.view)
                Helper.hideLoader()
                if(success) {
                    
                    UserDefaults.standard.set(LoginType.normal.rawValue, forKey: USERDEFAULTKEYS.LOGIN_TYPE)
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: SEGUE_IDENTIFIER.DASHBOARDSEGUE, sender: nil)
                    
                    
                }
                else {
                    Helper.printLog(response! as AnyObject?)
                    Helper.DeleteUserObject()
                    Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: response!, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                    })
                }
            }
            
        }
    }
    
    func validate() -> Bool {
        if !(txt_email.text?.isValidEmail())! {
            Helper.showAlert(sender: self, title: ALERTSTRING.REQUIRED, message: ALERTSTRING.VALID_EMAIL)
            return false
        }
        else if (txt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! < 6 {
            Helper.showAlert(sender: self, title: ALERTSTRING.REQUIRED, message: ALERTSTRING.VALID_PASSWORD_LEAST)
            return false
        }
        else {
            return true
        }
    }
    
    

}

extension LoginVC : UITextFieldDelegate {
    //    MARK: Textfield delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt_email {
            AppInstance.applicationInstance.user?.email = txt_email.text
        }
        else if textField == txt_password {
            AppInstance.applicationInstance.user?.password = txt_password.text
            UserDefaults.standard.set(txt_password.text, forKey: USERDEFAULTKEYS.PASSWORD)
        }
        else {
            print("Else")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}
