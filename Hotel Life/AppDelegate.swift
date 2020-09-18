//
//  AppDelegate.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/13/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import FBSDKCoreKit
import SDWebImage
import UserNotifications
import Fabric
import Crashlytics
import Firebase
import AdSupport
import CoreLocation
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SuggestionVCDelegate, NotificationDialogVCDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate{
    func noAction() {
        
    }
    
 var locationManager = CLLocationManager()
    var window: UIWindow?
    internal var shouldRotate = false
//    var orientationLock = UIInterfaceOrientationMask.all
    var isUserCheckedIn : Bool = false
    var notificationShown : Bool = false
    var notificationFrom : Bool = false
    var orientationLock = UIInterfaceOrientationMask.portrait
    var downloadModuleImageIndex = 0
    var moduleImagesArray:[String] = []
    var downloadQuestionImageIndex = 0
    var questionImagesArray:[String] = []
    var downloadDepartmentImageIndex = 0
    var departmentImagesArray:[String] = []
    var reservationModel : ReservationModel?
    var screenType : SubMenuDataType = .reservation
    let delegate = CustomNotification()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        let identifierManager = ASIdentifierManager.shared()
        //if identifierManager.isAdvertisingTrackingEnabled {
            let deviceId = UUID().uuidString
            print("deviceid===",deviceId)
            UserDefaults.standard.set(deviceId, forKey: "deviceId")
       // }
       
        //self.setRootView()
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Twitter.sharedInstance().start(withConsumerKey:KEYS.TwitterConsumerKey, consumerSecret:KEYS.TwitterConsumerSecret)
        TWTRTwitter.sharedInstance().start(withConsumerKey: KEYS.TwitterConsumerKey, consumerSecret:KEYS.TwitterConsumerSecret)
        
        
        //crashlytics initialization
        //Fabric.with([Crashlytics.self])

       // setupPushNotification()
      //  setupLocalNotification()
        if let userInfo = launchOptions {
            //print(userInfo)
            let data = userInfo[UIApplicationLaunchOptionsKey.remoteNotification]
            if let info = data as? [AnyHashable : Any] {
                notificationFrom = true
                notificationShown = true
                showPushMessage(data: info, delay: 5)
            }
        }
        //Enable Toolbar on Keyboard
        IQKeyboardManager.shared.enable = true
        isUserCheckedIn = false
        //Status bar to white
        UIApplication.shared.statusBarStyle = .lightContent
        //Let's use in after some time
        /* self.prefetchModuleImagesfromServer()
         self.prefetchQuestionImagesfromServer()
         self.prefetchDepartmentImagesFromServer()*/
        
        setBadge()
       

       
       
      
        return true
    }
    
    
    
    func setRootView(){
        
        
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! BaseNavigationController
            let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
            //let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "YouTubePlayerViewController") as! YouTubePlayerViewController
            navigationController.viewControllers = [rootViewController]
            self.window?.rootViewController = navigationController
       
        

    }
    
    @objc func setLaunchVCAsRootView(){
       

        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! BaseNavigationController
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "Dashboard") as! BaseTabBarVC
        navigationController.viewControllers = [rootViewController]
        self.window?.rootViewController = navigationController

        
    }
    
    
//    func application(_ application: UIApplication,
//                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return shouldRotate ? .allButUpsideDown : .portrait
//    }
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return shouldRotate ? .landscapeRight : .portrait
//    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (url.scheme?.contains("fb"))! {
                
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else if (url.scheme?.contains("twitter"))!{
            return TWTRTwitter.sharedInstance().application(application, open: url, options: [:])
        }
        else{
            return true
        }
    }
    
    
   func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {

            if (url.scheme?.contains("fb"))! {
                    ApplicationDelegate.shared.application(
                        app,
                        open: url,
                        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
                    )
            }
            else if (url.scheme?.contains("twitter"))!{
                return TWTRTwitter.sharedInstance().application(app, open: url, options: [:])
            }
            else{
                return true
            }
              return true
        }

    
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        if UserDefaults.standard.bool(forKey: "keyViewController"){
//            NSNotification.addObserver(self, forKeyPath: "HitEndpointAPI", options: .new, context: nil)
//        }
        notificationShown = false
        
        //Post Notification to stop pulsator Author Adil Mir
        if UserDefaults.standard.bool(forKey: "keyViewController"){
            NotificationCenter.default.post(name: NSNotification.Name("StopPulsator"), object: nil)
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
                if #available(iOS 10.0, *) {
                    let center = UNUserNotificationCenter.current()
                    center.getDeliveredNotifications(completionHandler: { (notificationRequests) in
                            if let data = notificationRequests.first?.request.content.userInfo{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    print("Foreground")
                                    if self.notificationFrom == false{
                                        if self.notificationShown{
                                            self.notificationShown = false
                                        } else {
                                              self.showPushMessage(data: data , delay: 0.1)
                                        }
                              
                                        
                                    }
                                }
                            }
                    })
                }
        
        
       
                self.setBadge()
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //Post Notification to stop pulsator Author Adil Mir
        if UserDefaults.standard.bool(forKey: "keyViewController"){
            NotificationCenter.default.post(name: NSNotification.Name("StartPulsator"), object: nil)
        }
    }
    
    

    func applicationDidBecomeActive(_ application: UIApplication) {
        setBadge()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

//    func sharedInstance() -> AppDelegate {
//        return UIApplication.shared.delegate as! AppDelegate
//    }
    
    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "BeachResorts")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving support

//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
    
    
    
    //MARK: - Images download
    //MARK: - Webservice
    func prefetchModuleImagesfromServer(){
        //get image urls from server
        let bizObject = BusinessLayer()
        bizObject.getModuleImagesFromServer { (status, imagesArray) in
            DispatchQueue.main.async(execute: {
                self.moduleImagesArray = imagesArray!
                if (imagesArray?.count)! > 0{
                    //                    download and cache images
                    self.downloadImage(imageURLstr: (imagesArray?[0])!, isModule: true, isQuestionaire: false, isDepartment: false)
                }
            })
        }
    }
    func prefetchQuestionImagesfromServer(){
        //get image urls from server
        let bizObject = BusinessLayer()
        bizObject.getQuestionImagesFromServer { (status, imagesArray) in
            DispatchQueue.main.async(execute: {
                self.questionImagesArray = imagesArray!
                if (imagesArray?.count)! > 0{
                    //                    download and cache images
                    self.downloadImage(imageURLstr: (imagesArray?[0])!, isModule: false, isQuestionaire: true, isDepartment: false)
                }
            })
        }
    }
    func prefetchDepartmentImagesFromServer() {
        let bizObject = BusinessLayer()
        bizObject.getDepartmentImagesFromServer{ (status, imageArray) in
            DispatchQueue.main.async(execute: {
                self.departmentImagesArray = imageArray!
                if (imageArray?.count)! > 0{
                    //                    download and cache images
                    self.downloadImage(imageURLstr: (imageArray?[0])!, isModule: false, isQuestionaire: false, isDepartment: true)
                }
            })
        }
    }
    
    func downloadImage(imageURLstr:String, isModule:Bool, isQuestionaire:Bool, isDepartment : Bool){
        SDWebImageDownloader.shared().downloadImage(with: URL(string: imageURLstr as String), options: [.highPriority, .scaleDownLargeImages], progress: nil, completed: { (image, data, error, success) in
            self.saveImage(imageURLstr: imageURLstr, image: image, isModule: isModule, isQuestionaire: isQuestionaire, isDepartment :isDepartment)
        })
    }
    
    func saveImage(imageURLstr:String, image:UIImage?, isModule:Bool, isQuestionaire:Bool, isDepartment : Bool){
        if image != nil{
            var index = 0
            var arrayImg:[String] = []
            if isModule{
               index = downloadModuleImageIndex
                arrayImg = moduleImagesArray
            }else if isQuestionaire{
                index = downloadQuestionImageIndex
                arrayImg = questionImagesArray
            }
            else if isDepartment{
                index = downloadDepartmentImageIndex
                arrayImg = departmentImagesArray
            }
            SDWebImageManager.shared().saveImage(toCache: image, for: URL(string: imageURLstr))
            if index < arrayImg.count{
                self.downloadImage(imageURLstr: (arrayImg[index]), isModule: isModule, isQuestionaire: isQuestionaire, isDepartment: isDepartment)
                if isModule{
                    downloadModuleImageIndex = downloadModuleImageIndex + 1
                }else if isQuestionaire{
                    downloadQuestionImageIndex = downloadQuestionImageIndex + 1
                }else if isDepartment{
                    downloadDepartmentImageIndex = downloadDepartmentImageIndex + 1
                }
            }
        }
    }
    // MARK: Local Notifications
    func setupLocalNotification(){
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
    }
//    MARK:Push Notifications
    func setupPushNotification(){
        if #available(iOS 10, *){
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            center.delegate = delegate
            let openAction = UNNotificationAction(identifier: NotificationIdentifiers.open, title: NotificationIdentifiers.open, options: UNNotificationActionOptions.foreground)
            let category = UNNotificationCategory(identifier: NotificationIdentifiers.customPush, actions: [openAction], intentIdentifiers: [], options: [])
            center.setNotificationCategories(Set([category]))
            UIApplication.shared.registerForRemoteNotifications()
        }
        else if #available(iOS 9, *) {
           UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        else{
           UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge,.alert,.sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("New Device token is ", deviceToken)
        UserDefaults.standard.set(deviceToken, forKey: USERDEFAULTKEYS.DEVICE_TOKEN)
        UserDefaults.standard.synchronize()

    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote notification registration failed \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("-------")
        print(application.applicationState)
        showPushMessage(data: userInfo, delay: 2)
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        // print("Push notification received: \(data)")
//        print("-------")
//        print(application.applicationState)
//        showPushMessage(data: data, delay: 2)
//
//    }
    
    
   
    func showPushMessage(data : [AnyHashable : Any], delay : TimeInterval) {
        notificationFrom = false
        print("show\(notificationFrom)")

        if let dict = data as NSDictionary? as! [String:Any]? {
            print(dict)
            let notificationObject = NotificationModel.init(dictionary: dict as NSDictionary)
            if notificationObject?.messageFrom == "order_suggestion"{
                self.perform(#selector(openSuggestionController(notificationObj:)), with: notificationObject, afterDelay: delay)
                return
            }
            if notificationObject?.messageFrom == "tray_pickup"{
                self.perform(#selector(openNotificationDialog(notificationObj:)), with: notificationObject, afterDelay: delay)
                return
            }
            if notificationObject?.messageFrom == "drink_reorder"{
                self.perform(#selector(openDrinkReorderController(notificationObj:)), with: notificationObject, afterDelay: delay)
                return
            }
            if notificationObject?.messageFrom == "hotel_marking"{
                self.perform(#selector(openMarketingController(notificationObj:)), with: notificationObject, afterDelay: delay)
                return
            }
        }
        
        if let dict = data["aps"] as? NSDictionary {
            print (dict)
            if let message = dict["alert"] as? String {
                 self.perform(#selector(showMessage(message:)), with: message, afterDelay: delay)
            }
        }
    }
    @objc func showMessage(message : String) {
        self.showConfirmationDialog(title: ALERTSTRING.TITLE, message: message)
        setBadge()
    }
    
    func setBadge(){
       
            UIApplication.shared.applicationIconBadgeNumber = 0
       
        
    }
    
    //MARK: - Show Notification Alert controller
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            if let topmostView = UIApplication.topViewController(){
                let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
                topmostView.definesPresentationContext = true
                objAlert.modalPresentationStyle = .overCurrentContext
                objAlert.view.backgroundColor = .clear
                objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
                topmostView.present(objAlert, animated: false) {
                }
            }
        })
    }
    
    //MARK: - Show Suggestion controller
    @objc func openSuggestionController(notificationObj: NotificationModel?){
        DispatchQueue.main.async(execute: {
            if let topmostView = UIApplication.topViewController(){
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.SUGESTIONVC) as! SuggestionVC
            objAlert.delegate = self
            objAlert.notificationObj = notificationObj
            topmostView.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            topmostView.present(objAlert, animated: false) {
            }
        }
        })
    }
    //MARK: - Drink reorder controller
    @objc func openDrinkReorderController(notificationObj: NotificationModel?){
        DispatchQueue.main.async(execute: {
            if let topmostView = UIApplication.topViewController(){
                let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.NotificationDialogVC) as! NotificationDialogVC
                topmostView.definesPresentationContext = true
                objAlert.modalPresentationStyle = .overCurrentContext
                objAlert.view.backgroundColor = .clear
                objAlert.delegate = self
                objAlert.notificationObj = notificationObj
                objAlert.lbl_message.text = notificationObj?.aps?.alert
                if let title = notificationObj?.message?.title {
                    objAlert.lbl_title.text = title
                }
                else {
                    objAlert.lbl_title.text = "Dezerland"
                }
                // yes action pending
                topmostView.present(objAlert, animated: false) {
                }
            }
        })
    }
    @objc func openMarketingController(notificationObj: NotificationModel?){
        DispatchQueue.main.async(execute: {
            if let topmostView = UIApplication.topViewController(){
                let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.NotificationMarketingVC) as! NotificationMarketingVC
                topmostView.definesPresentationContext = true
                objAlert.modalPresentationStyle = .overCurrentContext
                objAlert.view.backgroundColor = .clear
                objAlert.notificationObj = notificationObj
                objAlert.lbl_message.text = notificationObj?.aps?.alert
                if let title = notificationObj?.message?.title {
                    objAlert.lbl_title.text = title
                }
                else {
                    objAlert.lbl_title.text = "Dezerland"
                }
                // yes action pending
                topmostView.present(objAlert, animated: false) {
                }
            }
        })
    }
    @objc func openNotificationDialog(notificationObj: NotificationModel?){
        DispatchQueue.main.async(execute: {
            if let topmostView = UIApplication.topViewController(){
                let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.NotificationDialogVC) as! NotificationDialogVC
                topmostView.definesPresentationContext = true
                objAlert.modalPresentationStyle = .overCurrentContext
                objAlert.view.backgroundColor = .clear
                objAlert.delegate = self
                objAlert.notificationObj = notificationObj
                objAlert.lbl_message.text = notificationObj?.aps?.alert
                if let title = notificationObj?.message?.title {
                    objAlert.lbl_title.text = title
                }
                else {
                    objAlert.lbl_title.text = "Dezerland"
                }
                
                // yes action pending
                topmostView.present(objAlert, animated: false) {
                }
            }
        })
    }
 
    //    MARK: Pickup tray delegate
    func yesAction(_obj:NotificationModel?){
        print("yes")
        if _obj?.messageFrom == "drink_reorder"{
            reorder(id: _obj?.message?.previous_order_id)
        }
        else {
            let obj = BusinessLayer()
            obj.confirmTrayPickup(obj: _obj!) { (status, title, message) in
                // confirmed
            }
        }
        
    }
    func reorder(id : String?) {
        UserDefaults.standard.set(false, forKey: "isFromOrderHistoryDetailVC")
        BusinessLayer().getReorderMenuDetail(appointmentId: id) { (status, message, order, selectedMenu) in
                let obj = BusinessLayer()
                DispatchQueue.main.async {
                    Helper.showLoader(title: LOADER_TEXT.loading)
                }
            if let menuArr = order?.alohaMenu {
                var screenType = SubMenuDataType.tabs_quantity_selection
                
                if let mode = order?.orderMode {
                    screenType = Helper.getScreenType(orderMode: mode)
                }
                var beachLocation = false
                if order?.orderMode == 7{
                    beachLocation = true
                }else {
                    beachLocation = false
                }
                obj.calculateAlohaTax(arr: menuArr, orderMode : Helper.getOrderMode(screenType: screenType, beachLocation: beachLocation)) { (status, alohaOrder, message) in
                    
                    DispatchQueue.main.async {
                        Helper.hideLoader()
                    }
                    if status
                    {
                        if let alohaOrder = alohaOrder {

                            if let menus = alohaOrder.alohaMenu {
                                alohaOrder.subTotal = "\(String.init(format: "%.2f", Helper.getAlohaMenuQuantityTotal(menuArray: menus)))"
                            }
                            alohaOrder.afterDiscount = alohaOrder.calculateSubTotalAfterDiscount()
                            if let charge = selectedMenu?.tax?.service_charge {
                                alohaOrder.serviceCharge = alohaOrder.calculateServiceCharge(charge: charge)
                            }
                            if let charge = selectedMenu?.tax?.delivery_charge {
                                alohaOrder.deliveryCharge = alohaOrder.calculateDeliveryCharge(charge: charge, percent: 0)
                                if let percent = selectedMenu?.tax?.delivery_charge_percent {
                                    alohaOrder.deliveryCharge = alohaOrder.calculateDeliveryCharge(charge: charge, percent: percent)
                                }
                            }
                            if let charge = selectedMenu?.tax?.state_tax {
                                alohaOrder.stateTax = alohaOrder.calculateStateTax(charge: charge)
                            }
                            if let charge = selectedMenu?.tax?.county_tax {
                                alohaOrder.countyTax = alohaOrder.calculateCountyTax(charge: charge)
                            }
                            alohaOrder.total = alohaOrder.calculateTotal()
                            
//                            // save is drink status in aloha menu
                            if let items = order?.alohaMenu {
                                for item in items {
                                    if item.is_drink == true {
                                        if let alohaMenus = alohaOrder.alohaMenu {
                                            for menu in alohaMenus {
                                                if menu.posItemId == item.posItemId {
                                                    menu.is_drink = item.is_drink
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            let objPreviewVC : AlohaOrderPreview = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.AlohaOrderPreview) as! AlohaOrderPreview
                            objPreviewVC.order = alohaOrder
                            objPreviewVC.order.reservationModel = order?.reservationModel
                            objPreviewVC.screenType = screenType
                            objPreviewVC.selectedMenu = selectedMenu
                            objPreviewVC.titleBarText = selectedMenu?.label
                            DispatchQueue.main.async(execute: {
                                UIApplication.topViewController()?.navigationController?.pushViewController(objPreviewVC, animated: true)
                            })
                        }
                    }
                    else {
//                        Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                    }
                }
            }
            
//            let objPreviewVC : AlohaOrderPreview = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.AlohaOrderPreview) as! AlohaOrderPreview
//            objPreviewVC.order = order
//            objPreviewVC.order.reservationModel = order?.reservationModel
//            if let mode = order?.orderMode {
//                objPreviewVC.screenType = Helper.getScreenType(orderMode: mode)
//            }
//            //                    objPreviewVC.selectedMenu = self.selectedMenu
//            //                    objPreviewVC.titleBarText = self.titleBarText
//            DispatchQueue.main.async(execute: {
//                UIApplication.topViewController()?.navigationController?.pushViewController(objPreviewVC, animated: true)
//            })
        }
    }
//    MARK: SUGGESTION DELEGATE
    func confirmAction(_obj:NotificationModel?){
        //        MARK: Confirm
        if _obj?.message?.time_modify == true {
            print("confirmed")
            _obj?.message?.action = "confirm"
            if let type = _obj?.message?.subMenuDataType {
                self.screenType = type
            }
            self.modifySuggestion(objNotification: _obj!)
        }
        else{
            changeCompleteOrder(_obj : _obj)
        }
    }
    func newRequestAction(_obj:NotificationModel?){
        //        MARK: Modify
        // we ahve differnt flow for kid zone so keeping this functionality different
        if _obj?.message?.subMenuDataType == .kid_zone {
            // if you want to midify date only then use this one
//            planetKidsModification(_obj: _obj)
            
            // to show reservation screen and modify order from there
            changeCompleteOrder(_obj: _obj)
        }
        else {
//            if you want to just modify date time only and not change whole reservation then show date and time screen
//            showDateTimeModificationSection(_obj: _obj)
            
            // to show reservation screen and modify order from there
            changeCompleteOrder(_obj: _obj)
        }
        
    }
    
    func changeCompleteOrder(_obj:NotificationModel?){
        DispatchQueue.main.async {
            if let topmostView = UIApplication.topViewController(){
                let menu = Menu()
                menu.module_id = _obj?.message?.reservationModel?.module_id
                menu.department_Id = _obj?.message?.reservationModel?.department_id
                menu.items_attributes = _obj?.items_attributes
                if let type = _obj?.message?.subMenuDataType {
                    menu.subMenuDataType = type
                }
                if let title = _obj?.message?.title {
                    menu.label = title
                }
                if let type = _obj?.items_attributes?.instant_order {
                    menu.orderType = type ? OrderType.direct : OrderType.indirect
                }
                ScreenController.shared.setupScreen(menu: menu, viewController: topmostView, reserved: true, specialScreenType: nil)
            }
        }
    }
    
    func modifySuggestion(objNotification: NotificationModel){
        //get image urls from server
        let bizObject = BusinessLayer()
        bizObject.modifySuggestion(obj: objNotification, screenType : self.screenType,  { (status, reservationObj, title, message) in
            DispatchQueue.main.async(execute: {
                if status {
                    self.reservationModel = reservationObj
                    if !(self.reservationModel?.subMenuDataType == .def){
                        self.screenType = (reservationObj?.subMenuDataType)!
                    }
                    self.reservationModel?.alertTitle = title
                    self.reservationModel?.alertMessage = message
                    if let title = objNotification.message?.title {
                        // to show only confirmation dialog and not show reservation page
                        self.showConfirmationDialog(title: title,  message: message)
                    }
                    // to show reservation detail after order is confirmed
//                    self.alertDismissed()
                }
                else{
                    Helper.showAlert(sender: UIApplication.topViewController()!, title: title, message: message)
                }
            })
        })
    }
    
    func alertDismissed(){
        if let topmostView = UIApplication.topViewController(){
            switch screenType {
            case .reservation:
                let controller : ConfirmationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ConfirmationVC) as! ConfirmationVC
                if let name = self.reservationModel?.module_name{
                   controller.navTitle = name
                }
                controller.reservationModel = self.reservationModel
                controller.screenType = self.screenType
//                controller.selectedMenu = self.selectedMenu

                DispatchQueue.main.async(execute: {
                    topmostView.navigationController?.pushViewController(controller, animated: true)
                })
            case .submenu_selection:
                let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
                if let name = self.reservationModel?.module_name{
                    controller.titleBarText = name
                }else{
                    controller.titleBarText = ""
                }
                controller.reservation = reservationModel
                controller.screenType = self.screenType
                controller.showDate = true
                controller.showTime = true
                DispatchQueue.main.async(execute: {
                    topmostView.navigationController?.pushViewController(controller, animated: true)
                })
            case .service_selection:
                let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
                if let name = self.reservationModel?.module_name{
                    controller.titleBarText = name
                }else{
                    controller.titleBarText = ""
                }
                controller.reservation = reservationModel
                controller.screenType = self.screenType
                controller.showDate = true
                controller.showTime = true
                DispatchQueue.main.async(execute: {
                    topmostView.navigationController?.pushViewController(controller, animated: true)
                })
            case .quantity_selection:
                let controller : OrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.OrderVC) as! OrderVC
                controller.showDate = true
                if let name = self.reservationModel?.module_name{
                    controller.titleBarText = name
                    if name == "Dine Now" {
                        controller.showDate = false
                        controller.showChair = true
                        controller.showTax = true
                    }
                    else{
                        controller.showDate = true
                    }
                }else{
                    controller.titleBarText = ""
                }
                controller.reservation = reservationModel
                controller.screenType = self.screenType
                
                DispatchQueue.main.async(execute: {
                    topmostView.navigationController?.pushViewController(controller, animated: true)
                })
            case .kid_zone:
                let controller : PlanetKidsOrderVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.PlanetKidsOrderVC) as! PlanetKidsOrderVC
//                controller.titleBarText = self.reservationModel?.module_name
                controller.reservation = reservationModel
                DispatchQueue.main.async(execute: {
                    if let controller = topmostView as? BaseViewController {
                        controller.deactivateView(controller.view)
                    }
                    topmostView.navigationController?.pushViewController(controller, animated: true)
                })
            default:
                let controller : ConfirmationVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.ConfirmationVC) as! ConfirmationVC
                if let name = self.reservationModel?.module_name{
                    controller.navTitle = name
                }else{
                    controller.navTitle = ""
                }
                controller.reservationModel = self.reservationModel
                controller.screenType = self.screenType
                DispatchQueue.main.async(execute: {
                    topmostView.navigationController?.pushViewController(controller, animated: true)
                })
                
            }
        }
        
    }

    func planetKidsModification(_obj:NotificationModel?) {
        if let id = _obj?.message?.reservationModel?.department_id{
            Helper.getDepartment(departmentId: id, {(status, message, dept) in
                if status {
                    let objCustomTable : BookingDayVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.BookingDayVC) as! BookingDayVC
                    objCustomTable.selectedMenu.module_id = _obj?.message?.reservationModel?.module_id
                    objCustomTable.selectedMenu.department_Id = _obj?.message?.reservationModel?.department_id
                    objCustomTable.selectedMenu.order_Id = _obj?.message?.reservationModel?._id
                    objCustomTable.tableCellType = .none
                    objCustomTable.titleBarText = _obj?.message?.title
                    objCustomTable.isModification = true
                    if let number = _obj?.message?.reservationModel?.number_of_people {
                        objCustomTable.totalPerson = number
                    }
                    if let arr = dept {
                        for depObj in arr {
                            if let menus = depObj.items{
                                if menus.count > 0{
                                    for menu in menus{
                                        menu.module_id = id
                                    }
                                    depObj.items = menus
                                }
                            }
                        }
                        objCustomTable.department = arr
                    }
                    
                    DispatchQueue.main.async(execute: {
                        if let topmostView = UIApplication.topViewController(){
                            topmostView.navigationController?.pushViewController(objCustomTable, animated: true)
                        }
                    })
                }
                else{
                    DispatchQueue.main.async(execute: { () -> Void in
                    })
                }
            })
        }
    }
    func showDateTimeModificationSection (_obj:NotificationModel?) {
        if _obj?.message?.time_modify == true {
            print("new request")
            let objDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
            objDateTime.notificationObj = _obj
            objDateTime.suggestion = true
            objDateTime.titleBarText = _obj?.message?.title
            if _obj?.message?.subMenuDataType == .service_selection || _obj?.message?.subMenuDataType == .reservation || _obj?.message?.subMenuDataType == .submenu_selection{
                objDateTime.showTimeView = true
            }else{
                objDateTime.showTimeView = false
            }
            if _obj?.message?.subMenuDataType == .reservation {
                if _obj?.items_attributes?.is_restaurant == false {
                    objDateTime.showDuration = true
                    objDateTime.showPersonView = false
                    objDateTime.showSpecialRequest = false
                }
                else {
                    objDateTime.showPersonView = true
                    objDateTime.showSpecialRequest = true
                    objDateTime.showDuration = false
                }
            }
            
            DispatchQueue.main.async(execute: {
                if let topmostView = UIApplication.topViewController(){
                    topmostView.navigationController?.pushViewController(objDateTime, animated: true)
                }
            })
        }
    }
    
    
}

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
}


extension UINavigationController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let _ = self.topViewController as? SelectSeatVC {
            return .landscapeLeft
        }
        return .portrait
    }
    
    override open var shouldAutorotate: Bool{
        return true
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let _ = self.topViewController as? SelectSeatVC {
            return .landscapeRight
        }
        return .portrait
    }
}
