//
//  SuiteVC.swift
//  Hotel Life
//
//  Created by Amit Verma on 09/04/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class SuiteVC: BaseViewController, UIGestureRecognizerDelegate {
    var navController : UINavigationController?
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_temperature: UILabel!
    @IBOutlet weak var suiteLabel: UILabel!
    @IBOutlet weak var btn_flag: UIButton!
    
    
    @IBOutlet weak var lblBooking: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCheckIn_CheckOut: UILabel!
    @IBOutlet weak var lblGuest: UILabel!
    @IBOutlet weak var lblRoom: UILabel!
    @IBOutlet weak var lblSuitsNo: UILabel!
    
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblAddres: UILabel!
    
    @IBOutlet weak var lblBookingId2: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if let checkin = Helper.ReadUserObject(){
            if let bookingId = checkin.booking_number{
                lblBooking.text = "Booking ID : \(bookingId)"
                lblBookingId2.text = "Booking ID : \(bookingId)"
            }
            
            lblName.text = checkin.name
           // lblHotelName.text = checkin.name
            //lblAddres.text = checkin.address
            if let checkIn = checkin.arrival_date{
                if let checkOut = checkin.departure_date{
                    let checckinDate = Helper.getDateFrom(string: checkIn, format: "yyyy-MM-dd")
                    let convertedDateString = Helper.getStringFromDate(format: "EEE, MMM d", date: checckinDate!)
                    let checkoutDate = Helper.getDateFrom(string: checkOut, format: "yyyy-MM-dd")
                    let convertedCheckoutDateString = Helper.getStringFromDate(format: "EEE, MMM d", date: checkoutDate!)
                    lblCheckIn_CheckOut.text = "\(convertedDateString) - \(convertedCheckoutDateString)"
                }
            }
            
            var totalGuest = 0;
            if let adults = checkin.adults{
                totalGuest = Int(adults) ?? 0
            }
            if let children = checkin.children{
                totalGuest = totalGuest + (Int(children) ?? 0)
            }
            lblGuest.text = String(totalGuest)
            if let units = checkin.units{
                lblRoom.text = String(units)
            }
            
            
            if let roomNumber = Helper.getRoomNumber(){
                lblSuitsNo.text = roomNumber
            }
        }
    }
    @objc func didTapLabelDemo(sender: UITapGestureRecognizer)
    {
        print("you tapped label \(sender)")
        self.setFlipViewController()
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController!.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
    }
    
    

    func setFlipViewController(){
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController!.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
    }
    
    
    /*@IBAction func digitalRoomKeyAction(_ sender: Any) {
        
        let mobileKeysDidSetupEndpoint = UserDefaults.standard.bool(forKey: "mobileKeysDidSetupEndpoint")
        if mobileKeysDidSetupEndpoint{
            let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: "AssaAbloyVC") as! AssaAbloyVC
            UserDefaults.standard.set(true, forKey: "isLockButtonPresed")
            DispatchQueue.main.async(execute: {
                self.navController?.pushViewController(objUpgrade, animated: true)
            })
        } else{
        
        let message = ALERTSTRING.WouldYouLikeToGetDigitalKey
        
        if let topmostView = UIApplication.topViewController(){
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.NotificationDialogVC) as! NotificationDialogVC
            topmostView.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            objAlert.delegate = self
            objAlert.notificationObj = nil
            objAlert.lbl_message.text = message
            
            objAlert.lbl_title.text = ALERTSTRING.TITLE
            
            // yes action pending
            topmostView.present(objAlert, animated: false) {
            }
            
        
//        let message = ALERTSTRING.WouldYouLikeToGetDigitalKey
//        let confirmAlertCtrl = UIAlertController(title: ALERTSTRING.TITLE, message: message, preferredStyle: .alert)
//
//        let confirmAction = UIAlertAction(title: BUTTON_TITLE.Yes, style: .destructive) { _ in
//            let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: "AssaAbloyVC") as! AssaAbloyVC
//            UserDefaults.standard.set(true, forKey: "isLockButtonPresed")
//            DispatchQueue.main.async(execute: {
//                self.navigationController?.pushViewController(objUpgrade, animated: true)
//            })
//        }
//        confirmAlertCtrl.addAction(confirmAction)
//
//        let cancelAction = UIAlertAction(title: BUTTON_TITLE.No, style: .cancel, handler: { (action) in
//        })
//        confirmAlertCtrl.addAction(cancelAction)
//
//        self.present(confirmAlertCtrl, animated: true, completion: nil)
    }
    }
    }
   */
    
    
    func getInvitationCode(){
//        DispatchQueue.main.async(execute: { () -> Void in
//            // self.activateView(self.view, loaderText: LOADER_TEXT.loading)
//        })
//
//        let endpointId : String = UserDefaults.standard.value(forKey: "deviceId") as! String
//        BusinessLayer().generateInvitaionCode(dict: ["endpointId" : endpointId]) { (success, message ,response)  in
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.deactivateView(self.view)
//
//                if success{
//                    print(response)
//                    if let invitationCode = response?["invitationCode"] as? String{
//
//                        let newString = invitationCode.replacingOccurrences(of: "-", with: " - ")
//                        UserDefaults.standard.set(newString, forKey: "invitationCode")
//                        Helper.showAlert(sender: self, title: "", message: "Digital Key Generation in process, you will be notified when it is generated")
//                        kAppDelegate.mobileKeysController?.didPressRegistrationButton(invitationCode)
//
//                    }
//                    else if response?["code"] as?Int == 10008{
//                        self.deleteEndPointID()
//                    }
//
//                }else{
//
//                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Data not found")
//                }
//            })
//        }
        
    }
    
    func deleteEndPointID(){
//        DispatchQueue.main.async(execute: { () -> Void in
//            // self.activateView(self.view, loaderText: LOADER_TEXT.loading)
//        })
//        
//        let endpointId : String = UserDefaults.standard.value(forKey: "deviceId") as! String
//        BusinessLayer().deleteEndPointID(dict: ["endpointId" : endpointId]) { (success, message ,response)  in
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.deactivateView(self.view)
//                
//                if success{
//                    print(response)
//                    self.getInvitationCode()
//                }else{
//                    
//                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Data not found")
//                }
//            })
//        }
        
    }
    
    

}

extension SuiteVC:NotificationDialogVCDelegate{
    func noAction() {
        
    }
    
    func yesAction(_obj: NotificationModel?) {
         /* UserDefaults.standard.set(false, forKey: "isLockButtonPresed")
//        getInvitationCode()
        let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: "AssaAbloyVC") as! AssaAbloyVC
        UserDefaults.standard.set(true, forKey: "isLockButtonPresed")
        DispatchQueue.main.async(execute: {
            self.navController?.pushViewController(objUpgrade, animated: true)
        })*/
    }
}
