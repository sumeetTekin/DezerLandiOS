//
//  ViewController.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/13/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
//import XLPagerTabStrip

protocol BaseTabBarDelegate {
    func chnageToHomePage()
    func changePageController(storyboardIdentifier : String?, viewController : BaseViewController?)
    
}


class BaseTabBarVC: TabImageTitleVC, OptionVCDelegate, UIGestureRecognizerDelegate {
    
    var sharedInstanse : BaseTabBarVC?
    let tabDelegate : BaseTabBarDelegate? = nil
    
    var isReload = false
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_temperature: UILabel!
    @IBOutlet weak var suiteLabel: UILabel!
    @IBOutlet weak var btn_flag: UIButton!
    var languagePicker : UIPickerView = UIPickerView()
    var supportedLanguages : [String] = []
    var pages : [PageModel] = []
     override func viewDidLoad() {
        Helper.logScreen(screenName: "Main screen", className: "BaseTabBarVC")
        self.menuYOffset = 80 //72
        super.viewDidLoad()
        self.tabMargin = 0
        
        self.navigationController?.isNavigationBarHidden = false;
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // change selected bar color
        

        
         self.lbl_temperature.isHidden = true
        
        self.setLanguage()
        
        let bizObject = BusinessLayer()
        bizObject.getWeatherData({ (status, temperature) in
            DispatchQueue.main.async(execute: {
                self.lbl_temperature.isHidden = false
                if let temp = temperature {
                        // restricting to 0 decimal spaces
                        self.lbl_temperature.text = String.init(format: "%.0f°F", temp)
                }
                else{
                        // restricting to 0 decimal spaces
                        self.lbl_temperature.text = String.init(format: "70°F")
                }
            })
        })
        setupViewControllers()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Update_Suite"), object: nil, queue: nil) { (notification) in
            self.updateSuiteLabel()
        }
        
     
    }
    
    func setFlipViewController(){
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: "SuiteVC") as! SuiteVC
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        search.navController = self.navigationController
        self.navigationController!.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
    }
    
    func setupViewControllers() {
        self.pages.removeAll()
        let objHome = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.HOME) as! HomeVC
        objHome.navController = self.navigationController
        objHome.parentView = self.view
        objHome.tabDelegate = self
        let homePageModel = PageModel()
        
        homePageModel.image = #imageLiteral(resourceName: "home")
        homePageModel.highlightedImage = #imageLiteral(resourceName: "home_hvr")
        homePageModel.title = TITLE.HOME
        homePageModel.viewController = objHome
        homePageModel.isSelected = true
        self.pages.append(homePageModel)
        
        let objLoyality = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.LOYALITY) as! LoyalityVC
        objLoyality.navController = self.navigationController
        let loyaltyPageModel = PageModel()
        loyaltyPageModel.image = #imageLiteral(resourceName: "loyality")
        loyaltyPageModel.highlightedImage = #imageLiteral(resourceName: "loyality_hvr")
        loyaltyPageModel.title = TITLE.LOYALTY
        loyaltyPageModel.viewController = objLoyality
        loyaltyPageModel.isSelected = false
        self.pages.append(loyaltyPageModel)
        
        let objFeedback = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.FEEDBCAK) as! FeedbackVC
        objFeedback.navController = self.navigationController
        let feedbackPageModel = PageModel()
        feedbackPageModel.image =  #imageLiteral(resourceName: "stay")
        feedbackPageModel.highlightedImage = #imageLiteral(resourceName: "stay_hvr")
        feedbackPageModel.title =  TITLE.FEEDBACK
        feedbackPageModel.viewController = objFeedback
        feedbackPageModel.isSelected = false
        self.pages.append(feedbackPageModel)
        self.setPageModelArray(self.pages)
    }
    //save this to according to design
    func setupViewControllersAnotherView() {
        self.pages.removeAll()
        let objHome = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "ShareOnSocialMediaVC") as! ShareOnSocialMediaVC
        objHome.navController = self.navigationController
        //objHome.parentView = self.view
        objHome.tabDelegate = self
        let homePageModel = PageModel()
        
        homePageModel.image = #imageLiteral(resourceName: "home")
        homePageModel.highlightedImage = #imageLiteral(resourceName: "home_hvr")
        homePageModel.title = "Media"//TITLE.HOME
        homePageModel.viewController = objHome
        homePageModel.isSelected = true
        self.pages.append(homePageModel)
        
        let objLoyality = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.LOYALITY) as! LoyalityVC
        objLoyality.navController = self.navigationController
        let loyaltyPageModel = PageModel()
        loyaltyPageModel.image = #imageLiteral(resourceName: "loyality")
        loyaltyPageModel.highlightedImage = #imageLiteral(resourceName: "loyality_hvr")
        loyaltyPageModel.title = TITLE.LOYALTY
        loyaltyPageModel.viewController = objLoyality
        loyaltyPageModel.isSelected = false
        self.pages.append(loyaltyPageModel)
        
        let objFeedback = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.FEEDBCAK) as! FeedbackVC
        objFeedback.navController = self.navigationController
        let feedbackPageModel = PageModel()
        feedbackPageModel.image =  #imageLiteral(resourceName: "stay")
        feedbackPageModel.highlightedImage = #imageLiteral(resourceName: "stay_hvr")
        feedbackPageModel.title =  TITLE.FEEDBACK
        feedbackPageModel.viewController = objFeedback
        feedbackPageModel.isSelected = false
        self.pages.append(feedbackPageModel)
        self.setPageModelArray(self.pages)
    }
    
    
    
    
    func setLanguage(){
        //SetLanguage choosen flat
        var langArray: Array<String> = UserDefaults.standard.value(forKey: USERDEFAULTKEYS.APPLE_LANGUAGES) as! Array
        switch langArray[0] {
        case LANGUAGE_KEY.ENGLISH, LANGUAGE_CODE.ENGLISH:
            self.btn_flag.setImage(#imageLiteral(resourceName: "flag_us"), for: .normal)
        case LANGUAGE_KEY.SPANISH, LANGUAGE_CODE.SPANISH:
            self.btn_flag.setImage(#imageLiteral(resourceName: "flag_sp"), for: .normal)
        case LANGUAGE_KEY.PORTUGESE, LANGUAGE_CODE.PORTUGESE:
            self.btn_flag.setImage(#imageLiteral(resourceName: "flag_br"), for: .normal)
        case LANGUAGE_KEY.RUSSIAN, LANGUAGE_CODE.RUSSIAN:
            self.btn_flag.setImage(#imageLiteral(resourceName: "flag_ru"), for: .normal)
        default:
            self.btn_flag.setImage(#imageLiteral(resourceName: "flag_us"), for: .normal)
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if let user = AppInstance.applicationInstance.user  {
            if let name = user.name {
                let nameArr = name.components(separatedBy: " ")
                self.lbl_username.text = nameArr.first?.appending("!")
            }
        }
        else{
            self.lbl_username.text = ""
        }
        updateSuiteLabel()
        
        // manually calling viewWillAppear for refreshing Dashboard
        for controller in self.pages {
            controller.viewController?.viewWillAppear(animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for controller in self.pages {
            controller.viewController?.viewDidAppear(animated)
        }
    }
    func updateSuiteLabel() {
        
       
        
//        DispatchQueue.main.async {
//            self.suiteLabel.text = ""
//            if kAppDelegate.isUserCheckedIn /*&& Helper.ReadUserObject()?.userType == UserType.hotelGuest.rawValue*/{
//                if let roomNumber = Helper.getRoomNumber(), roomNumber != "" {
//                    self.suiteLabel.isUserInteractionEnabled = true // Remember to do this
//                    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//                        target: self, action: #selector(self.didTapLabelDemo))
//                    self.suiteLabel.addGestureRecognizer(tap)
//                    tap.delegate = self
//                    self.suiteLabel.text = "Room Details" //\(roomNumber)"
//                }
//                else {
//                    self.suiteLabel.isUserInteractionEnabled = false
//                    self.suiteLabel.text = ""
//                }
//            }
//        }
        
        
    }
    
    @objc func didTapLabelDemo(sender: UITapGestureRecognizer)
    {
        print("you tapped label \(sender)")
        self.setFlipViewController()
    }
    
//    func selectTab(from:Int, to: Int){
//        super.moveToViewController(at: to, animated: true)
//        super.updateIndicator(for: self, fromIndex: from, toIndex: to)
//        super.buttonBarView.moveTo(index: 0, animated: true, swipeDirection: .none, pagerScroll: .yes)
//    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        //self.selectTab(from: 2, to: 0)
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: "OptionVC") as! OptionVC
        objUpgrade.delegate = self
        self.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            self.navigationController?.present(objUpgrade, animated: true, completion: {
            })
        })
    }
    
    @IBAction func actionSelectLanguage(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)


        let actionEnglish = UIAlertAction(title: ALERTSTRING.LANGUAGE_ENGLISH, style: .default, handler: { action in
            DispatchQueue.main.async(execute: {
                //English
                self.changeToLanguage(LANGUAGE_KEY.ENGLISH)
            })
        })
        var langArray: Array<String> = UserDefaults.standard.value(forKey: USERDEFAULTKEYS.APPLE_LANGUAGES) as! Array
        if langArray[0] == LANGUAGE_KEY.ENGLISH{
            actionEnglish.isEnabled = true
        }
        actionSheet.addAction(actionEnglish)

        let actionSpanish = UIAlertAction(title: ALERTSTRING.LANGUAGE_SPANISH, style: .default, handler: { action in
            DispatchQueue.main.async(execute: {
                //Spanish
                self.changeToLanguage(LANGUAGE_KEY.SPANISH)
            })
        })
        if langArray[0] == LANGUAGE_KEY.SPANISH{
            actionEnglish.isEnabled = true
        }
        actionSheet.addAction(actionSpanish)

        let actionPortuguese = UIAlertAction(title: ALERTSTRING.LANGUAGE_PORTUGUESE, style: .default, handler: { action in
            DispatchQueue.main.async(execute: {
                //Portuguese
                self.changeToLanguage(LANGUAGE_KEY.PORTUGESE)
            })
        })
        if langArray[0] == LANGUAGE_KEY.PORTUGESE{
            actionEnglish.isEnabled = true
        }
        actionSheet.addAction(actionPortuguese)

        let actionRussian = UIAlertAction(title: ALERTSTRING.LANGUAGE_RUSSIAN, style: .default, handler: { action in
            DispatchQueue.main.async(execute: {
                //Portuguese
                self.changeToLanguage(LANGUAGE_KEY.RUSSIAN)
            })
        })
        if langArray[0] == LANGUAGE_KEY.RUSSIAN{
            actionRussian.isEnabled = true
        }
        actionSheet.addAction(actionRussian)

        let actionCancel = UIAlertAction(title: ALERTSTRING.CANCEL, style: .destructive, handler: { action in

        })
        actionSheet.addAction(actionCancel)

        self.present(actionSheet, animated: true, completion: {

        })
        
        
        
    }
    
    private func changeToLanguage(_ langCode: String) {
        if Bundle.main.preferredLocalizations.first != langCode {
            let message = ALERTSTRING.LANGUAGE_CHANGE_MESSAGE
            let confirmAlertCtrl = UIAlertController(title: ALERTSTRING.APP_RESTART_REQUIRED, message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: BUTTON_TITLE.CloseNow, style: .destructive) { _ in
                self.updateLanguageAtServer(langCode)
            }
            confirmAlertCtrl.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: BUTTON_TITLE.Cancel, style: .cancel, handler: nil)
            confirmAlertCtrl.addAction(cancelAction)
            
            present(confirmAlertCtrl, animated: true, completion: nil)
        }
    }
    func updateLanguageAtServer(_ langCode : String){
        let updateUser:UserModel = AppInstance.applicationInstance.user!
        updateUser.default_language = Helper.getCodeForLang(langCode)
        DispatchQueue.main.async(execute: { () -> Void in
            Helper.showLoader(title: LOADER_TEXT.loading)
        })
        
        let bizObject = BusinessLayer()
        bizObject.updateProfile(user: updateUser ,{ (status, message) in
            DispatchQueue.main.async(execute: {
                Helper.hideLoader()
                if status {
                    self.setLanguage()
                    Helper.changeToLanguage(langCode)
                }
                else {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            })
        })
    }
    
    func editprofile(){
       // self.setupViewControllersAnotherView()
        let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.SIGNUP) as! SignUpVC
        objUpgrade.isEditingProfile = true
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objUpgrade, animated: true)
        })
    }
    
    func orderHistory() {
        let objUpgrade = Helper.getOrderHidtoryStoryboard().instantiateViewController(withIdentifier: "OrderHistoryVC") as! OrderHistoryVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objUpgrade, animated: true)
        })
    }
    
    func roomTemprature() {
        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PlayCardTransactionVC") as? PlayCardTransactionVC{
            vc.paymentType = "paymentCard"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func lock() {
//        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentCardsViewController") as? PaymentCardsViewController{
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentCardsViewController") as? PaymentCardsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    func customerSupportAction() {
        let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.SupportVC) as! SupportVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objUpgrade, animated: true)
        })
    }
    
    
    func signOut(){
        if let topController = UIApplication.topViewController() {
            DispatchQueue.main.async(execute: {
                Helper.showLoader(title: LOADER_TEXT.loading)
                //topController.activateView(topController.view, loaderText: )
            })
            if let controller = topController as? BaseViewController {
               
                
                
            
            }
            let bizObject:BusinessLayer = BusinessLayer()
            bizObject.signOut({ status, message in
                if let controller = topController as? BaseViewController {
                    DispatchQueue.main.async(execute: {
                    //   controller.deactivateView(controller.view)
                    })
                    
                }
                if status {
                    DispatchQueue.main.async(execute: {
                        Helper.SaveBooking(nil)
                        Helper.DeleteUserObject()
                        kAppDelegate.isUserCheckedIn = false
                        UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.ALREADY_LOGIN)
                        UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.LOGIN_TYPE)
                        UserDefaults.standard.removeObject(forKey: USERDEFAULTKEYS.PASSWORD)
                        UserDefaults.standard.removeObject(forKey: "login")
                        UserDefaults.standard.removeObject(forKey: "invitationCode")
                        UserDefaults.standard.removeObject(forKey: "mobileKeysDidSetupEndpoint")
                        if UserDefaults.standard.bool(forKey: "mobileKeysDidStartup"){
                            print("Terminating Endpoint.....")
                        //kAppDelegate.mobileKeysController?.terminateEndpoint()
                        }
                        UserDefaults.standard.synchronize()
                        AppInstance.applicationInstance.userLoggedIn = false
                        
                        AppInstance.applicationInstance.isCampaignListCalled = false
                       // kAppDelegate.mobileKeysController?.terminateEndpoint()// terminate end point
                        kAppDelegate.setRootView()
                        //self.navigationController?.popToRootViewController(animated: true)
                    })
                    
                }
                else{
                    Helper.showAlert(sender: topController, title: ALERTSTRING.ERROR, message: message)
                }
                
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension BaseTabBarVC : BaseTabBarDelegate{
    func changePageController(storyboardIdentifier: String?, viewController: BaseViewController?) {
        self.setupViewControllersAnotherView()
    }
    func chnageToHomePage(){
        self.viewDidLoad()
    }
    
    
}

