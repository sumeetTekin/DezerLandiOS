//
//  SignUpQuestionsVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/15/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import SDWebImage
class SignUpQuestionsVC: BaseViewController {
    
    @IBOutlet weak var option1Lbl: UILabel!
    @IBOutlet weak var option2Lbl: UILabel!
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option1Image: UIImageView!
    @IBOutlet weak var option2Image: UIImageView!
    
    var questionArray : [SignupQuestion] = []
    var loginType : LoginType = .normal
    var editProfile = false
    var selectedQuestion = 0
    var userType:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Signup questions screen", className: "SignUpQuestionsVC")
        
        // Do any additional setup after loading the view.
        
        
        if questionArray.count == 0{
            DispatchQueue.main.async {
                self.activateView(self.view, loaderText: LOADER_TEXT.SigningIn)
            }
            if editProfile{
                let user = AppInstance.applicationInstance.user!
                self.updateUser(updateUser: user)
            } else {
                self.signUp()
            }
        }else{
            self.loadQuestionContent()
            //Option 1 image
            option1Image.isUserInteractionEnabled = true
            let recognizer1 = UITapGestureRecognizer()
            recognizer1.addTarget(self, action: #selector(SignUpQuestionsVC.option1Action(_:)))
            option1Image.addGestureRecognizer(recognizer1)
            //Option 2 image
            option2Image.isUserInteractionEnabled = true
            let recognizer2 = UITapGestureRecognizer()
            recognizer2.addTarget(self, action: #selector(SignUpQuestionsVC.option2Action(_:)))
            option2Image.addGestureRecognizer(recognizer2)
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        if selectedQuestion == 0{
            DispatchQueue.main.async(execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            selectedQuestion = selectedQuestion - 1
            self.loadQuestionContent()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadQuestionContent(){
        if selectedQuestion < questionArray.count{
            if questionArray[selectedQuestion].l_Text == questionArray[selectedQuestion].selectedAnswer{
                option1Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .normal)
                option2Btn.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
            }else if questionArray[selectedQuestion].r_Text == questionArray[selectedQuestion].selectedAnswer{
                option1Btn.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
                option2Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .normal)
            }else{
                option1Btn.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
                option2Btn.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
            }
            self.option1Lbl.text = questionArray[selectedQuestion].l_Text
            self.option2Lbl.text = questionArray[selectedQuestion].r_Text
            self.option1Image.sd_setImage(with: URL.init(string:questionArray[selectedQuestion].l_Image! ), completed: nil)
            self.option2Image.sd_setImage(with: URL.init(string:questionArray[selectedQuestion].r_Image! ), completed: nil)
        }
    }
    
    @IBAction func option1Action(_ sender: UIButton) {
        if questionArray.count > selectedQuestion{
            option1Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .normal)
            option1Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .highlighted)
            option1Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .selected)
            option2Btn.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
            questionArray[selectedQuestion].selectedAnswer = questionArray[selectedQuestion].l_Text
            selectedQuestion = selectedQuestion + 1
        }
        if selectedQuestion < questionArray.count{
            self.perform(#selector(loadQuestionContent), with: nil, afterDelay: 0.1)
            //self.loadQuestionContent()
        }else{
            if editProfile{
                AppInstance.applicationInstance.user?.questionary = Questionary.modelsFromSignupQuestionArray(array: questionArray)
                let user = AppInstance.applicationInstance.user!
                self.updateUser(updateUser: user)
            } else {
                self.signUp()
            }
            
        }
    }
    
    @IBAction func option2Action(_ sender: UIButton) {
        if questionArray.count > selectedQuestion{
            option2Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .normal)
            option2Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .highlighted)
            option2Btn.setImage(#imageLiteral(resourceName: "checkIcon"), for: .selected)
            option1Btn.setImage(#imageLiteral(resourceName: "uncheckIcon"), for: .normal)
            questionArray[selectedQuestion].selectedAnswer = questionArray[selectedQuestion].r_Text
            selectedQuestion = selectedQuestion + 1
        }
        if selectedQuestion < questionArray.count{
            self.perform(#selector(loadQuestionContent), with: nil, afterDelay: 0.1)
            //self.loadQuestionContent()
        }else{
            if editProfile{
                 AppInstance.applicationInstance.user?.questionary = Questionary.modelsFromSignupQuestionArray(array: questionArray)
                let user = AppInstance.applicationInstance.user!
                self.updateUser(updateUser: user)
            } else {
                 self.signUp()
            }
           
        }
    }
    
    func RouteToThanksVC(){
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.THANKS) as! ThanksVC
            self.navigationController?.pushViewController(objDashboard, animated: true)
    }
    
    func RouteToDashboard(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller is BaseTabBarVC {
                DispatchQueue.main.async(execute: {
                    self.navigationController!.popToViewController(controller, animated: true)
                })
                break
            }
        }
        
    }
    
    //    MARK: API CALL
    func signUp() {
        
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.SigningIn)
        }
        if questionArray.count != 0{
           AppInstance.applicationInstance.user?.questionary = Questionary.modelsFromSignupQuestionArray(array: questionArray)
        }
        
        
        
        let bizObject:BusinessLayer = BusinessLayer()
        bizObject.signUpNormal { (success, response) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if(success) {
                    print(success)
                    UserDefaults.standard.set(self.loginType.rawValue, forKey: USERDEFAULTKEYS.LOGIN_TYPE)
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
    
    
    func updateUser(updateUser:UserModel){
        DispatchQueue.main.async {
            self.activateView(self.view, loaderText: LOADER_TEXT.Updating)
        }
        let bizObject = BusinessLayer()
        bizObject.updateProfile(user: updateUser ,{ (status, message) in
            DispatchQueue.main.async(execute: {
                self.deactivateView(self.view)
                if status {
                    DispatchQueue.main.async(execute: {
                        self.RouteToDashboard()
                    })
                }
                else {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            })
        })
        
    }
}
