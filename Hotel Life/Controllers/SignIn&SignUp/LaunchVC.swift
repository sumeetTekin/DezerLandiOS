//
//  LaunchVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
class LaunchVC: BaseViewController {
    @IBOutlet weak var jointBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
//    @IBOutlet weak var poweredByLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        jointBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        jointBtn.titleLabel?.lineBreakMode = .byClipping
        
        signInBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        signInBtn.titleLabel?.lineBreakMode = .byClipping
        
        facebookBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        facebookBtn.titleLabel?.lineBreakMode = .byClipping
        
//        poweredByLbl.adjustsFontSizeToFitWidth = true
//        poweredByLbl.lineBreakMode = .byClipping
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        if (UserDefaults.standard.object(forKey: USERDEFAULTKEYS.ALREADY_LOGIN) != nil) && (UserDefaults.standard.object(forKey: USERDEFAULTKEYS.ALREADY_LOGIN) as? Bool)!{
            if let loginController = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.LOGIN) as? LoginVC {
                
                if let type = UserDefaults.standard.object(forKey: USERDEFAULTKEYS.LOGIN_TYPE) as? Int{
                    if type == LoginType.facebook.rawValue {
                        loginController.loginType = LoginType.facebook
                        if let user = Helper.ReadUserObject(){
                            AppInstance.applicationInstance.user = user
                            self.registerWithFacebook(loginUser: user)
                        }
                        
                    }
                    else{
                        DispatchQueue.main.async(execute: {
                            self.navigationController?.pushViewController(loginController, animated: false)
                        })
                    }
                }
                else{
                    DispatchQueue.main.async(execute: {
                        self.navigationController?.pushViewController(loginController, animated: false)
                    })
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        kAppDelegate.setupPushNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func joinAction(_ sender: UIButton) {
        AppInstance.applicationInstance.user = UserModel()
    }
    
    @IBAction func facebookLoginAction(_ sender: UIButton) {
        loginToFacebook()
    }
    
    func showLoader() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.SigningIn)
        })
        
    }
    func hideLoader(){
        DispatchQueue.main.async(execute: { () -> Void in
            self.deactivateView(self.view)
        })
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if  let loginController = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.LOGIN) as? LoginVC{
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(loginController, animated: true)
            })
        }
        
        
    }
    func loginToFacebook() {
        
        let manager : LoginManager = LoginManager()
        manager.logOut()
        //manager.loginBehavior = .systemAccount
        // facebook permissions
        manager.logIn(permissions: ["public_profile", "email"], from: self, handler: { (result, error) in
            if (error != nil) {
                print("Process error")
            } else if (result?.isCancelled)! {
                print("Cancelled")
            } else {
                print("Logged in")
                if (result?.declinedPermissions.contains("email"))! {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ALERTSTRING.FACEBOOK_EMAIL_REQUIRED)
                } else {
                    self.getFacebookDetails()
                }
            }
        })
    }
    
    func getFacebookDetails(){
//        self.showLoader()
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields" : "id,name,email,birthday"]).start(completionHandler: {(connection, result, error) in
                if (error == nil) {
//                    self.hideLoader()
                    print(result ?? "No result")
                    let loginUser:UserModel=UserModel()
                    loginUser.email = (result as! NSDictionary)["email"] as? String
                    loginUser.userId = (result as! NSDictionary)["id"] as? String
                    loginUser.facebook_id = (result as! NSDictionary)["id"] as? String
                    loginUser.name = (result as! NSDictionary)["name"] as? String
                    if let birthdayStr = (result as! NSDictionary)["birthday"] as? String{
                        let date = Helper.getDateFromString(string: birthdayStr, formatString: DATEFORMATTER.MMDDYYYY)
                        loginUser.birthday = Helper.getStringFromDate(format: DATEFORMATTER.MMDDYYYY, date: date)
                    }
                    AppInstance.applicationInstance.user = loginUser
                    
                    self.registerWithFacebook(loginUser: AppInstance.applicationInstance.user!)
                    
                    
                }
                else{
//                    self.hideLoader()
                }
            })
        }
    }
    func registerWithFacebook(loginUser : UserModel) {
        DispatchQueue.main.async(execute: {
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject:BusinessLayer=BusinessLayer()
        bizObject.loginFacebook({ (success, message, response) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                    self.deactivateView(self.view)
                if(success) {
                    UserDefaults.standard.set(LoginType.facebook.rawValue, forKey: USERDEFAULTKEYS.LOGIN_TYPE)
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: SEGUE_IDENTIFIER.FACEBOOKLOGIN, sender: nil)
                }
                else {
                    // need to discuss for some alternative
                    if message == "Error occurred while retrieving the data" /*message == ""*/ {
                        AppInstance.applicationInstance.user = loginUser
                        
                        self.getQuestions(completion: { questions in
                            if questions.count != 0{
                                let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SignUpQuestionsVC") as! SignUpQuestionsVC
                                objUpgrade.questionArray = questions
                                objUpgrade.loginType = .facebook
                                DispatchQueue.main.async(execute: {
                                    self.navigationController?.pushViewController(objUpgrade, animated: true)
                                })
                            }else{
                                self.signUp()
                            }
                            
                            
                        })
                     }
                    else{
                        Helper.DeleteUserObject()
                        Helper.printLog(response! as AnyObject?)
                        Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: message, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                        })
                    }
                }
            })
            
        })
    }
    
    //    MARK: API CALL
    func signUp() {
        
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.SigningIn)
        }
        
        let bizObject:BusinessLayer = BusinessLayer()
        bizObject.signUpNormal { (success, response) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if(success) {
                    print(success)
                    UserDefaults.standard.set(LoginType.facebook.rawValue, forKey: USERDEFAULTKEYS.LOGIN_TYPE)
                    UserDefaults.standard.synchronize()
                    self.RouteToThanksVC()
                }
                else {
                    Helper.DeleteUserObject()
                    Helper.printLog(response! as AnyObject?)
                    Helper.showAlertAction(sender: self, title: ALERTSTRING.TITLE, message: response!, buttonTitles: [ALERTSTRING.OK], completion: { (response) in
                    })
                }
            })
        }
    }
    
    
    func RouteToThanksVC(){
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.THANKS) as! ThanksVC
            self.navigationController?.pushViewController(objDashboard, animated: true)
    }
    
    
    func getQuestions (completion : @escaping ([SignupQuestion]) -> Void) {
        let bizObject:BusinessLayer=BusinessLayer()
        bizObject.getQuestionary({(status, signupQuestions) in
            if status == true {
                if let questions = signupQuestions {
                    completion(questions)
                }
            }
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if (segue.identifier == SEGUE_IDENTIFIER.SIGNUP){
//            let signupController : SignUpVC = segue.destination as! SignUpVC
//            if let user = sender as? UserModel {
//              signupController.facebookUserModel = user
//            }
            
//        }
    }
 

}
