//
//  CheckInCardVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/18/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class CheckInCardVC: BaseViewController, UpgradeSuiteVCDelegate, AlertVCDelegate {
    var booking : Booking?
    var arrival = ""
    var departure = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let booking = booking {
            if let arrival = booking.arrival {
                self.arrival = arrival
            }
            if let departure = booking.departure {
                self.departure = departure
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Helper.logScreen(screenName: "Checkin and reservation details Screen", className: "CheckInCardVC")

        self.navigationItem.title = "Mobile Check In"
        let btn_back = UIBarButtonItem.init(image:  #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
    }
    @objc func backAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func upgradeAction(sender:UIButton){
        
        let message = ALERTSTRING.RoomUpgradation
        let confirmAlertCtrl = UIAlertController(title: ALERTSTRING.TITLE, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: ALERTSTRING.OK, style: .cancel) { _ in
            
        }
        confirmAlertCtrl.addAction(confirmAction)
        
//        let cancelAction = UIAlertAction(title: BUTTON_TITLE.No, style: .cancel, handler: { (action) in
//        })
//        confirmAlertCtrl.addAction(cancelAction)
        
        self.present(confirmAlertCtrl, animated: true, completion: nil)
        /*let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.UPGRADE_SUITE) as! UpgradeSuiteVC
        objUpgrade.delegate = self
        self.definesPresentationContext = true
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            self.navigationController?.present(objUpgrade, animated: true, completion: {
            })
        })*/
    }
    
    @objc func CheckInAction(sender:UIButton){
        checkinSOAP()
    }
    func checkinSOAP() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        
        let bizObject = BusinessLayer()
        bizObject.soapCheckin(bookingNumber: self.booking?.bookingNumber, { (status, message) in
            if status == true {
                self.booking?.roomNumber = Helper.GetBooking()?.roomNumber
                self.checkin()
            }
            else{
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
            }
        })
    }
    
    func checkin() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        
        let bizObject = BusinessLayer()
        let checkinDate = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
        bizObject.checkinUser(bookingNumber: booking?.bookingNumber, roomNumber: booking?.roomNumber, checkinTime : checkinDate, arrival_date: booking?.arrival, departure_date: booking?.departure, adults: booking?.adults, children: booking?.children, units: booking?.units, {(status,message) in
            DispatchQueue.main.async(execute: {
                self.deactivateView(self.view)
                if status {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Update_Suite"), object: nil, userInfo: nil)
                    Helper.SaveBooking(self.booking)
                    kAppDelegate.isUserCheckedIn = true
                    AppInstance.applicationInstance.user?.check_in_sms = true
                    AppInstance.applicationInstance.user?.booking_number = self.booking?.bookingNumber
                    self.showConfirmationDialog(title: "Check in", message: "You have checked in for your stay")
                }
                else{
                    Helper.showAlert(sender: self, title: "Error", message: message)
                }
            })
        })
    }
    
    @objc func changeCardAction(sender:UIButton){
        let objCard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.EDIT_CARD) as! EditCardVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objCard, animated: true)
        })
    }
    
    //MARK: - UpgradeSuite Delegate method
    func alertDismissed(){
        
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
//
//            self.dismissAlertView()
//
//        })
//        confirmAlertCtrl.addAction(cancelAction)
//
//        self.present(confirmAlertCtrl, animated: true, completion: nil)
        
        
    }
    
    
    func dismissAlertView(){
        
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController is BaseTabBarVC{
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil, userInfo: nil)
                })
                return
            }
        }
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objDashboard, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil, userInfo: nil)
        })
       
    }
    
    
    
    func updateAlertDismissed() {
        
    }
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            self.definesPresentationContext = true
            objAlert.delegate = self
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.present(objAlert, animated: false) {
            }
        })
    }
}


extension CheckInCardVC: UITableViewDelegate, UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // get a reference to our storyboard cell
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CHECKIN_CREDIT, for: indexPath as IndexPath) as! CheckInTableViewCell
            cell.backgroundColor = .clear
            cell.changeBtn.addTarget(self, action: #selector(self.changeCardAction(sender:)), for: .touchUpInside)
            cell.configureCell(indexPath: indexPath)
            if let num = booking?.cardNumber {
                cell.subTitle.text = num
            }
            else {
                cell.subTitle.text = ""
            }
//            if let exp = booking?.expiry {
//                cell.lbl_expiry.text = "Expiry: \(exp)"
//            }
            cell.lbl_expiry.text = ""

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CHECKIN_DATES, for: indexPath as IndexPath) as! CheckInTableViewCell
            cell.backgroundColor = .clear
            cell.configureCell(indexPath: indexPath)
            cell.subTitle.text = "\(arrival) - \(departure)"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CHECKIN_UPGRADE, for: indexPath as IndexPath) as! CheckInTableViewCell
            cell.backgroundColor = .clear
            cell.upgradeBtn.addTarget(self, action: #selector(self.upgradeAction(sender:)), for: .touchUpInside)
            cell.checkInBtn.addTarget(self, action: #selector(self.CheckInAction(sender:)), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CHECKIN_CREDIT, for: indexPath as IndexPath) as! CheckInTableViewCell
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.row {
        case 2:
            return 140
        default:
            return 100
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
}

extension CheckInCardVC:NotificationDialogVCDelegate{
    func noAction() {
        
    }
    
    func yesAction(_obj: NotificationModel?) {
        
    }
    
    
}

