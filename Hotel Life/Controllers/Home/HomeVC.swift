//
//  HomeVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/14/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit
//import CoreBluetooth
import  CoreLocation
import UserNotifications
//import XLPagerTabStrip
class HomeVC: BaseViewController, NotificationDialogVCDelegate,CLLocationManagerDelegate{
//    var itemInfo = IndicatorInfo(title: "View")
    var navController : UINavigationController?
    var parentView : UIView?
    var menuArray : [Menu] = []
    var department : Department?
    var shouldUpdate : Bool = true
    var fromCheckout = false
    var showCheckoutdialog = false
    var menuPlaceholderImageArray : [UIImage] = [#imageLiteral(resourceName: "directionToPark"), #imageLiteral(resourceName: "socialMedia"), #imageLiteral(resourceName: "autoMuseum"), #imageLiteral(resourceName: "goKart"), #imageLiteral(resourceName: "virtualReality"), #imageLiteral(resourceName: "bowling"), #imageLiteral(resourceName: "games"), #imageLiteral(resourceName: "requestCar"), #imageLiteral(resourceName: "bookYourEvent"), #imageLiteral(resourceName: "offerNew")]
   var locationManager = CLLocationManager()
    let refreshControl : UIRefreshControl = UIRefreshControl()
    //var blutoothManager = CBPeripheralManager()
    
    
    var tabDelegate : BaseTabBarDelegate?
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let scanner = QRCodeScannerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUser), name: NSNotification.Name(rawValue: "mobileKeysDidSetupEndpoint"), object: nil)
        // Do any additional setup after loading the view.
     locationManager.delegate = self
        Helper.logScreen(screenName: "Dashboard screen", className: "HomeVC")

        self.addRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDashboard), name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil)
        if shouldUpdate {
            self.updateDashboard()
        }
        
        
      
    }
    func addRefreshControl(){
        
        refreshControl.tintColor = COLORS.THEME_YELLOW_COLOR
        refreshControl.addTarget(self, action: #selector(updateDashboard), for: .valueChanged)
        self.myCollectionView.addSubview(refreshControl)
        self.myCollectionView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDetails()
        
        
      
       
//        push test
//        kAppDelegate.reorder(id: "5b7bd3849386a1354cb16d87")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Bundle.main.preferredLocalizations.first != AppInstance.applicationInstance.user?.default_language {
            let message = ALERTSTRING.LANGUAGE_CHANGE_MESSAGE
            let confirmAlertCtrl = UIAlertController(title: ALERTSTRING.APP_RESTART_REQUIRED, message: message, preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: BUTTON_TITLE.CloseNow, style: .destructive) { _ in
                if let lang = AppInstance.applicationInstance.user?.default_language {
                    Helper.changeToLanguage(lang)
                }
            }
            confirmAlertCtrl.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: BUTTON_TITLE.Cancel, style: .cancel, handler: { (action) in
            })
            confirmAlertCtrl.addAction(cancelAction)
            
            self.present(confirmAlertCtrl, animated: true, completion: nil)
        }
       
        
    }
    
    @IBAction func digitalRoomKeyAction(_ sender: Any) {
        
        
      
    }
    
    
    func yesAction(_obj: NotificationModel?) {
        if fromCheckout{
           self.checkOutUser()
             fromCheckout = false
            return
        } else {
//            UserDefaults.standard.set(false, forKey: "isLockButtonPresed")
//            self.getInvitationCode()
        
        }
    }
    
    func noAction() {
        if fromCheckout{
            fromCheckout = false
        }
    }
    
    func updateDetails() {
        if let check_in_sms = AppInstance.applicationInstance.user?.check_in_sms, check_in_sms == true {
            self.getCardDetail()
//            self.updateCheckinEnquiry()
        }
    }
    func getCardDetail() {
        if let num = Helper.getBookingNumber() {
            let obj = BusinessLayer()
            obj.folioDetailCard(resno: num) { (status, message) in
                print(message)
                if status {
                    if let booking = Helper.GetBooking() {
                        booking.cardNumber = message
                        Helper.SaveBooking(booking)
                    }
                }
            }
        }
        
    }
    func updateCheckinEnquiry () {
        
        if let bookingNumber = Helper.getBookingNumber() {
            let obj = BusinessLayer()
            obj.checkinEnquiry(bookingNumber: bookingNumber, {(status, message, booking)  in
                if status {
                    Helper.SaveBooking(booking)
                    if booking?.level == BOOKINGSTATUS.OUT {
                       self.checkOut()
                    }
                }
                else{
                    //Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                }
            })
        }
    }
    
    func checkOut() {
        if let bookingNumber = AppInstance.applicationInstance.user?.booking_number {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            
            let checkoutDate = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
            let bizObject = BusinessLayer()
            bizObject.checkoutUser(bookingNumber: bookingNumber, checkoutTime: checkoutDate, {(status,message,booking_number)  in
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    if status {
                        kAppDelegate.isUserCheckedIn = false
                        Helper.SaveBooking(nil)
                        AppInstance.applicationInstance.user?.booking_number = nil
                        AppInstance.applicationInstance.user?.room_number = nil
                        AppInstance.applicationInstance.user?.check_in_sms = false
                        if let user = AppInstance.applicationInstance.user {
                            Helper.SaveUserObject(user)
                        }
                        
                        let booking = Booking()
                        booking.bookingNumber = booking_number
                        Helper.SaveBooking(booking)
                        
                        for viewController in (self.navController?.viewControllers)!{
                            if viewController is BaseTabBarVC{
                                self.navigationController?.popToViewController(viewController, animated: true)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil, userInfo: nil)
                                return
                            }
                        }
                        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
                        self.navController?.pushViewController(objDashboard, animated: true)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil, userInfo: nil)
                    }
                    else{
                        Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                    }
                })
            })
        }
        else{
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.INVALID_REQUEST)
        }
    }
    
    /*func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is on.")
           
            break
        case .poweredOff:
            print("Bluetooth is Off.")
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unsupported:
            break
        case .unknown:
            print("Bluetooth is Unknown.")
            break
        default:
            break
        }
    }*/
    //MARK: - Webservice
    @objc func updateDashboard(){
        DispatchQueue.main.async(execute: { () -> Void in
           if let view = self.parentView {
                self.activateView(view, loaderText: LOADER_TEXT.loading)
            }
        })
        let bizObject = BusinessLayer()
        bizObject.getDashboardMenu({(status, menus) in
            DispatchQueue.main.async {
                self.shouldUpdate = false
                if let view = self.parentView {
//                Helper.hideLoader()
                    self.deactivateView(view)
                }
                
                if menus.count > 0
                {
                    self.menuArray = menus
                }
                for menu in self.menuArray {
                    if menu.submoduleType == .checkout {
                        if let checkin = AppInstance.applicationInstance.user?.check_in_sms, checkin == false {
                            self.getCheckinDetail(showBookings : false)
                        }
                    }
                }
                self.loader.stopAnimating()
                self.refreshControl.endRefreshing()
                self.myCollectionView.reloadData()
//                UIApplication.shared.endIgnoringInteractionEvents()
            }
        })
    }
    func getCheckinDetail(showBookings : Bool) {
        
        if let user = AppInstance.applicationInstance.user,let userType =  Helper.ReadUserObject()?.userType,userType == UserType.hotelGuest.rawValue   {
            if let name = user.getSoapParamName() {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.activateView(self.view, loaderText: LOADER_TEXT.loading)
                })
                let obj = BusinessLayer()
                obj.userBookingEnquiry(name: name) { (status, message, bookings)  in
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.deactivateView(self.view)
                    })
                    if status {
                        if bookings.count == 1 {
                            if let booking = bookings.first {
                                self.checkinProcess(booking: booking)
                            }
                        }
                        else {
                            if showBookings {
                                let bookingvc = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.SelectBookingsVC) as! SelectBookingsVC
                                bookingvc.bookings = bookings
                                bookingvc.delegate = self
                                self.definesPresentationContext = true
                                bookingvc.modalPresentationStyle = .overCurrentContext
                                bookingvc.modalTransitionStyle = .crossDissolve
                                bookingvc.view.backgroundColor = .clear
                                DispatchQueue.main.async(execute: {
                                    self.navController?.present(bookingvc, animated: true, completion: nil)
                                })
                            }
                        }
                    }
                    else{
                        Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                    }
                }
            }
        }
    }
    
    private func getSubMenus(menuId:String,_ completionHandler : @escaping ([Menu]) -> Void ){
        DispatchQueue.main.async(execute: { () -> Void in
           
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject = BusinessLayer()
        bizObject.getSubModuleMenu(menuId: menuId, {(status, message, subModules) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            completionHandler(subModules)
        })
    }
    
    private func getSubMenus(departmentID:String,_ completionHandler : @escaping ([Menu]) -> Void ){
        DispatchQueue.main.async(execute: { () -> Void in
           
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject = BusinessLayer()
        bizObject.getSubMenuFromDepartment(menuId: departmentID, {(status, message, subModules) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            completionHandler(subModules)
        })
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IndicatorInfoProvider
//    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return itemInfo
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil)
    }
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = Device.SCREEN_WIDTH/2 //Display Three elements in a row.
        collectionViewSize.height = Device.SCREEN_WIDTH/2 - Device.SCREEN_WIDTH/4.5
        return collectionViewSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        if kAppDelegate.isUserCheckedIn{
            let height = menuArray.count > 0 ? 125 : 0
            let size : CGSize = CGSize(width: 0, height: height)
            return size
        }else{
            let height = menuArray.count > 0 ? 75 : 0
            let size : CGSize = CGSize(width: 0, height: height)
            return size
        }
        
       
        // TODO: Hiding Digital key for now
//        if kAppDelegate.isUserCheckedIn{
//            size = CGSize(width: Device.SCREEN_WIDTH, height: 75)
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CELL_IDENTIFIER.DASHBOARD_FOOTER, for: indexPath as IndexPath) as! DashboardFooterReusableView
        
        if let keyButton = headerView.viewWithTag(10) as? UIButton {
            if kAppDelegate.isUserCheckedIn{
                keyButton.isHidden = false
            }else{
                keyButton.isHidden = true
            }
        }
        return headerView
    }
    
    // MARK: - UICollectionView Delegate
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return menuArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.DASHBOARD, for: indexPath as IndexPath) as! DashboardCell
        if indexPath.row < menuPlaceholderImageArray.count {
            cell.configureCell(indexPath: indexPath, menuObj:menuArray[indexPath.row], placeholderImage: menuPlaceholderImageArray[indexPath.row])
        }
        else{
            cell.configureCell(indexPath: indexPath, menuObj:menuArray[indexPath.row], placeholderImage: nil)
        }
        
         cell.backgroundColor = .clear
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        let menuObj = menuArray[indexPath.row]
        if !(menuObj.isEnabled) {
            Helper.showCancelDialog(title: menuObj.label ?? "Dezerland", message: menuObj.inactive_message ?? "Temporarily disabled", viewController: self)
            return
        }
        switch menuObj.submoduleType {
        case .directions:
            
            //tabDelegate?.changePageController(storyboardIdentifier: "", viewController: HomeVC.self as? BaseViewController)

            
            let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier:
                STORYBOARD.DIRECTIONS_MENU) as! DirectionsMenuVC
            objDirection.titleBarText = menuObj.label!
            objDirection.selectedMenu = menuObj
            DispatchQueue.main.async(execute: {
                self.navController?.pushViewController(objDirection, animated: true)
            })
        case .checkout:
            
            //Code for Assa Abloy Review
            fromCheckout = true
            let message = "Are you sure you want to check out?"
            
            if let topmostView = UIApplication.topViewController(){
                let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.NotificationDialogVC) as! NotificationDialogVC
                topmostView.definesPresentationContext = true
                objAlert.modalPresentationStyle = .overCurrentContext
                objAlert.view.backgroundColor = .clear
                objAlert.delegate = self
                objAlert.notificationObj = nil
                objAlert.lbl_message.text = message
                
                objAlert.lbl_title.text = "Dezerland"
                
                // yes action pending
                topmostView.present(objAlert, animated: false) {
                }
            }
            
            // Code for Asssa Abloy ReviewEnds Here
            
            //MARK: -----This code is commented for testing of Assa Abloy Build.It should be uncommented after testing.
           /* if let checkin = AppInstance.applicationInstance.user?.check_in_sms, checkin == true {
                let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier:
                    "CheckOutVC") as! CheckOutVC
                DispatchQueue.main.async(execute: {
                    self.navController?.pushViewController(objSubMenu, animated: true)
                })
            }else{
//                let objCheckIn = Helper.getMainStoryboard().instantiateViewController(withIdentifier:
//                    STORYBOARD.CHECKIN) as! CheckInVC
//                objCheckIn.titleBarText = menuObj.label!
//                DispatchQueue.main.async(execute: {
//                    self.navController?.pushViewController(objCheckIn, animated: true)
//                })
                self.getCheckinDetail(showBookings: true)
            }*/
        case .subCell:
            
            if menuObj.label == "Auto Museum"{
                
                //self.getQrCodeDetail(qrcodeValue: "automobile0-hRcDT4sEomd")
                self.scanQRCode(self)

                
                
                
            }else if menuObj.label == "Bowling"{
                if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
                    //vc.titleValue = menuObj.label!
                    self.navController?.pushViewController(vc, animated: true)
                }
                
//                if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ReservationFirstVC) as? ReservationFirstVC{
//                    vc.titleValue = menuObj.label!
//                    self.navController?.pushViewController(vc, animated: true)
//                }
                
                
            }
                
            
            
            else {
                //            if let checkin = AppInstance.applicationInstance.user?.checkIn, checkin == true {
                 let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier:
                     STORYBOARD.SUB_MENU) as! SubMenuVC
                 objSubMenu.titleBarText = menuObj.label!
                 getSubMenus(menuId: menuObj.department_Id!) { (menu) in
                     objSubMenu.menuArray = menu
                     objSubMenu.selectedMenu = menuObj
                     DispatchQueue.main.async(execute: {
                         self.navController?.pushViewController(objSubMenu, animated: true)
                     })
                 }
                //            }
                
                
                
//                if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ReservationFirstVC) as? ReservationFirstVC{
//                    vc.titleValue = menuObj.label!
//                    self.navController?.pushViewController(vc, animated: true)
//                }
            }
            
            
        case .sacoaCard:
            
                
            if let vc = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SacoaCardVC") as? SacoaCardVC{
                    self.navController?.pushViewController(vc, animated: true)
            }
           

        case .socialMediaShare:
            
            
            
            if let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier:
                STORYBOARD.ShareOnSocialMediaVC) as? ShareOnSocialMediaVC{
                DispatchQueue.main.async(execute: {
                    self.navController?.pushViewController(objSubMenu, animated: true)
                })
            }
                
            
        case .textDirection:
//            if let checkin = AppInstance.applicationInstance.user?.checkIn, checkin == true {
                let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DIRECTIONS_MENU) as! DirectionsMenuVC
                objDirection.titleBarText = menuObj.label!
                objDirection.selectedMenu = menuObj
                objDirection.isRequestForCar = true
                DispatchQueue.main.async(execute: {
                    self.navController?.pushViewController(objDirection, animated: true)
                })
//            }
            
            
        case .subMenu:
            
            
            if menuObj.label == "Games"{
                
                let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier:
                    STORYBOARD.SUB_MENU) as! SubMenuVC
                objSubMenu.titleBarText = menuObj.label!
                
                getSubMenus(menuId: menuObj.department_Id!) { (menu) in
                    
                    self.getSubMenus(departmentID: menu[0].department_Id ?? "") { (menu) in
                        objSubMenu.menuArray = menu
                        objSubMenu.selectedMenu = menuObj
                        objSubMenu.specialScreenType = .submenu_selection
                        DispatchQueue.main.async(execute: {
                            self.navController?.pushViewController(objSubMenu, animated: true)
                        })
                    }
                    
                }
                
                
            }else{
                
                let objSubMenu = Helper.getMainStoryboard().instantiateViewController(withIdentifier:
                    STORYBOARD.SUB_MENU) as! SubMenuVC
                objSubMenu.titleBarText = menuObj.label!
                
                getSubMenus(menuId: menuObj.department_Id!) { (menu) in
                    
                    self.getSubMenus(departmentID: menu[0].department_Id ?? "") { (menu) in
                        objSubMenu.menuArray = menu
                        objSubMenu.selectedMenu = menuObj
                        DispatchQueue.main.async(execute: {
                            self.navController?.pushViewController(objSubMenu, animated: true)
                        })
                    }
                    
                }
                
            }
            
            
            
            
        case .booking:
            
            getSubMenus(menuId: menuObj.department_Id!) { (menu) in
                DispatchQueue.main.async(execute: {
                    self.pushToDateTimeVC(menuObj.label!, withMenuItem: menu[0])
                })
            }
        }
        
    }
    
    func scanQRCode(_ sender: Any) {
        
        //QRCode scanner without Camera switch and Torch
        //let scanner = QRCodeScannerController()
        
        //QRCode with Camera switch and Torch
        //let scanner = QRCodeScannerController(cameraImage: UIImage(named: "camera"), cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "flash-on"), flashOffImage: UIImage(named: "flash-off"))
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
    
    
    private func pushToDateTimeVC(_ titleValue: String, withMenuItem  menu: Menu){
        
//        self.checkForReservation(menu: selectedMenu, {(status, reservationModel) in
//        if status {
//            }
//        else{
//
//            }
//        }
        
        
        let controllerDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
                controllerDateTime.titleBarText = menu.label
                controllerDateTime.selectedMenu = menu
        
                controllerDateTime.showPersonView = true
                
                controllerDateTime.showDuration = false
                controllerDateTime.showDateView = true
                controllerDateTime.showTimeView = true
                controllerDateTime.showSpecialRequest = true
                
                    switch titleValue {
                    case "Go Karts":
                        controllerDateTime.showOccation = false
                        controllerDateTime.showDateView = false
                        controllerDateTime.showTimeView = false
                    case "Virtual Reality":
                        controllerDateTime.showOccation = false
                    default:
                        controllerDateTime.showOccation = false
                    }
               
        
               controllerDateTime.tableCellType = .checkboxCell
               controllerDateTime.screenType = .reservation
        
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    self.navController?.pushViewController(controllerDateTime, animated: true)
                })
        
    }
    
    
    private func checkForReservation(menu : Menu ,_ completionHandler : @escaping (Bool,ReservationModel?) -> Void){
        // here module id will be parent id of selected menu
        // here dep id will be module id of selected menu
        
        let bizObject = BusinessLayer()
        
        if menu.orderType == .indirect{
            bizObject.getReservation(moduleId:menu.module_id! , departmentId:menu.department_Id!, { (status, reservationModel) in
                completionHandler(status,reservationModel)
            })
        }
        
    }
    
    
}


extension HomeVC: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
        
        scanner.delegate = nil
        self.getQrCodeDetail(qrcodeValue: result)
        
        
        
        
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        self.navigationController?.popViewController(animated: true)
        print("SwiftQRScanner did cancel")
    }
    
    
    private func getQrCodeDetail(qrcodeValue : String){
        
        DispatchQueue.main.async(execute: { () -> Void in
            if let view = self.parentView {
                self.activateView(view, loaderText: LOADER_TEXT.loading)
            }
        })
        let bizObject = BusinessLayer()
        bizObject.getQRCodeScanData(codeValue: qrcodeValue) { (status, data) in
            DispatchQueue.main.async {
                
                if status == true{
                    self.shouldUpdate = false
                    self.deactivateView(self.view)
                    
                    if let qrCodeVC = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.CarDetailVC) as? CarDetailVC{
                        qrCodeVC.qrCodeDetail = data[0]
                        self.navController?.pushViewController(qrCodeVC, animated: true)
                    }
                }else{
                    self.deactivateView(self.view)
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: TITLE.invalidQrCode)
                }
                
                
            }
        }
        
        
    }
    
    
    
}



extension HomeVC : SelectBookingDelegate {
    func selectedBooking(booking : Booking?, controller : SelectBookingsVC) {
        controller.dismiss(animated: true, completion: nil)
        
        if let booking = booking {
            self.checkinProcess(booking: booking)
        }
    }
    func checkinProcess(booking : Booking) {
 
        if booking.level == BOOKINGSTATUS.INH {
            checkin(booking: booking)
        }
        else if booking.level == BOOKINGSTATUS.NEW || booking.level == BOOKINGSTATUS.CNF || booking.level == BOOKINGSTATUS.CL{
            showCheckinDetail(booking: booking)
        }
        else if booking.level == BOOKINGSTATUS.OUT{
                Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: TITLE.checkedOut)
        }
        else {
           Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: TITLE.checkedOut)
        }
    }
    func showCheckinDetail (booking : Booking) {
        
        let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.CHECKIN_CARD) as! CheckInCardVC
        objDirection.booking = booking
        DispatchQueue.main.async(execute: {
            self.navController?.pushViewController(objDirection, animated: true)
        })
    }
    
    func checkin(booking : Booking) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        
        let bizObject = BusinessLayer()
        let checkinDate = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
        bizObject.checkinUser(bookingNumber: booking.bookingNumber, roomNumber: booking.roomNumber, checkinTime : checkinDate, arrival_date: booking.arrival, departure_date: booking.departure, adults: booking.adults, children: booking.children, units: booking.units, {(status,message) in
            DispatchQueue.main.async(execute: {
                self.deactivateView(self.view)
                if status {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Update_Suite"), object: nil, userInfo: nil)
                    Helper.SaveBooking(booking)
                    AppInstance.applicationInstance.user?.check_in_sms = true
                    kAppDelegate.isUserCheckedIn = true
                    AppInstance.applicationInstance.user?.booking_number = booking.bookingNumber
                    self.showConfirmationDialog(title: "Check in", message: "You have checked in for your stay")
                    
                }
                else{
                    Helper.showAlert(sender: self, title: "Error", message: message)
                }
            })
        })
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
extension HomeVC : AlertVCDelegate {
    func alertDismissed() {
        
        if showCheckoutdialog{
            showCheckoutdialog = false
            return
        }else{
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
        }
        /*let confirmAlertCtrl = UIAlertController(title: ALERTSTRING.TITLE, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: BUTTON_TITLE.Yes, style: .destructive) { _ in
            let objUpgrade = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: "AssaAbloyVC") as! AssaAbloyVC
            UserDefaults.standard.set(true, forKey: "isLockButtonPresed")
            DispatchQueue.main.async(execute: {
                self.navController?.pushViewController(objUpgrade, animated: true)
            })
        }
        confirmAlertCtrl.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: BUTTON_TITLE.No, style: .cancel, handler: { (action) in
            
            self.dismissAlertView()
            
        })
        confirmAlertCtrl.addAction(cancelAction)
        
        self.present(confirmAlertCtrl, animated: true, completion: nil)*/
        
        
        
        
        
      
    }
    
    
    func dismissAlertView(){
        
        if let controllers = self.navigationController?.viewControllers {
            for viewController in controllers {
                if viewController is BaseTabBarVC{
                    DispatchQueue.main.async(execute: {
                        self.navigationController?.popToViewController(viewController, animated: true)
                        self.myCollectionView.reloadData()
                        self.updateDetails()
                    })
                    return
                }
            }
        }
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        self.navigationController?.pushViewController(objDashboard, animated: true)
        self.myCollectionView.reloadData()
        self.updateDetails()
    }
    
    
    // Below code is for Assa Abloy Review.
    
    func checkOutUser() {
        if let bookingNumber = AppInstance.applicationInstance.user?.booking_number {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            
            let checkoutDate = Helper.getStringFromDate(format: DATEFORMATTER.YYYY_MM_DD_HH_MM, date: Date())
            
            let bizObject = BusinessLayer()
            bizObject.checkoutUser(bookingNumber: bookingNumber, checkoutTime: checkoutDate, {(status,message, new_booking_number) in
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    if status {
                        self.showCheckoutdialog = true
                        self.updateDashboard()
                        Helper.SaveTempBooking(Helper.GetBooking())
                        kAppDelegate.isUserCheckedIn = false
                        Helper.SaveBooking(nil)
                        AppInstance.applicationInstance.user?.booking_number = nil
                        AppInstance.applicationInstance.user?.room_number = nil
                        AppInstance.applicationInstance.user?.check_in_sms = false
                        if let user = AppInstance.applicationInstance.user {
                            Helper.SaveUserObject(user)
                        }
                        let booking = Booking()
                        booking.bookingNumber = new_booking_number
                        Helper.SaveBooking(booking)
                        UserDefaults.standard.set(nil, forKey: "invitationCode")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Update_Suite"), object: nil, userInfo: nil)
                      
                       self.showConfirmationDialog(title: "", message: "You have successfully Checked out.")
                    }
                    else{
                        Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                    }
                })
            })
        }
        else{
            Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: ERRORMESSAGE.INVALID_REQUEST)
        }
    }
}
//Assa Abloy Work
extension HomeVC{
    func getInvitationCode(){
        DispatchQueue.main.async(execute: { () -> Void in
            // self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        
        let endpointId : String = UserDefaults.standard.value(forKey: "deviceId") as! String
        BusinessLayer().generateInvitaionCode(dict: ["endpointId" : endpointId]) { (success, message ,response)  in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                
                if success{
                    print(response)
                    if let invitationCode = response?["invitationCode"] as? String{
                        
                        let newString = invitationCode.replacingOccurrences(of: "-", with: " - ")
                        UserDefaults.standard.set(newString, forKey: "invitationCode")
                         Helper.showAlert(sender: self, title: "", message: "Digital Key Generation in process, you will be notified when it is generated")
                        
                    }
                    else if response?["code"] as?Int == 10008{
                        self.deleteEndPointID()
                    }
                    
                }else{
                    
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Data not found")
                }
            })
        }
        
    }
    
    func deleteEndPointID(){
        DispatchQueue.main.async(execute: { () -> Void in
            // self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        
        let endpointId : String = UserDefaults.standard.value(forKey: "deviceId") as! String
        BusinessLayer().deleteEndPointID(dict: ["endpointId" : endpointId]) { (success, message ,response)  in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                
                if success{
                    print(response)
                    self.getInvitationCode()
                }else{
                    
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: "Data not found")
                }
            })
        }
        
    }
    
    @objc func notifyUser(){
        if let controller = UIApplication.topViewController(){
            
            
//            let content = UNMutableNotificationContent()
//            content.title = NSString.localizedUserNotificationString(forKey: "Key Genertaed", arguments: nil)
//            content.body = NSString.localizedUserNotificationString(forKey: "Digital Key has been successfully generated", arguments: nil)
//            content.sound = UNNotificationSound.default()
//            content.categoryIdentifier = "notify-test"
//
//            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
//            let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)
//
//            let center = UNUserNotificationCenter.current()
//            center.add(request)
            
            Helper.showAlert(sender: controller, title: "Key Genertaed", message: "Digital Key has been successfully generated")
        }
    }
}
