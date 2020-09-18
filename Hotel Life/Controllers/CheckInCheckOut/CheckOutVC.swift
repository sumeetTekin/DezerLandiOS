//
//  CheckOutVC.swift
//  BeachResorts
//
//  Created by jasvinders.singh on 9/19/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class CheckOutVC: BaseViewController {
    
//    var checkOutArray:[String] = ["View Bill", "Select a Payment Method"]
    var checkOutArray:[String] = ["View Bill"]
    var checkOutImageArray:[UIImage] = [#imageLiteral(resourceName: "img_edit"), #imageLiteral(resourceName: "img_card")]
    var menuPlaceholderImageArray : [UIImage] = [#imageLiteral(resourceName: "img_directions"), #imageLiteral(resourceName: "checkin")]
    var menuArray : [Menu] = []
    var isCheckedOut = false
    @IBOutlet weak var menuCollectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Checkout Screen", className: "CheckOutVC")

        // Do any additional setup after loading the view.
        self.loadMenuItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isCheckedOut {
            self.customBack()
        }
        self.navigationItem.title = "Mobile Check Out"
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back  
    }
    @objc public func backAction(_ sender : UIButton) {
        DispatchQueue.main.async(execute: {
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    public func loadMenuItems(){
        var labelArray : [String] = ["Directions\nto Airport","Request Car"]
        var imageArray : [UIImage] = [#imageLiteral(resourceName: "img_directions"),#imageLiteral(resourceName: "img_requestcar")]

        for i in 0..<labelArray.count {
            let menu = Menu()
            menu.label = labelArray[i]
            menu.cellImage = imageArray[i]
            menu.isEnabled = true
            menuArray.append(menu)
        }
    }
    
    
    
    @IBAction func checkOutAction(_ sender: UIButton) {
        
        checkoutSOAP()
        
    }
    func checkoutSOAP() {
        if let bookingNumber = AppInstance.applicationInstance.user?.booking_number {
            DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            
            let bizObject = BusinessLayer()
            bizObject.soapCheckout(bookingNumber: bookingNumber, { (status, message) in
                if status == true {
                    self.checkOut()
                }
                else{
                    Helper.showAlert(sender: self, title: "Error", message: message)
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
            bizObject.checkoutUser(bookingNumber: bookingNumber, checkoutTime: checkoutDate, {(status,message, new_booking_number) in
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    if status {
                        Helper.SaveTempBooking(Helper.GetBooking())
                        self.getBill()
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
                        self.isCheckedOut = true
                        //kAppDelegate.mobileKeysController?.terminateEndpoint()
                        UserDefaults.standard.set(nil, forKey: "invitationCode")
                        
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
    func customBack() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController is BaseTabBarVC{
                self.navigationController?.popToViewController(viewController, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil, userInfo: nil)
                return
            }
        }
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        self.navigationController?.pushViewController(objDashboard, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOAD_DASHBOARD"), object: nil, userInfo: nil)
    }
    func getBill() {
        var bookingNumber = ""
        if let num = Helper.getBookingNumber() {
            bookingNumber = num
        }
        else {
            return
        }
        DispatchQueue.main.async(execute: { () -> Void in
                self.activateView(self.view, loaderText: LOADER_TEXT.loading)
            })
            let bizObject = BusinessLayer()
            bizObject.folioEnquiry(bookingNumber: bookingNumber, {(status,message,data) in
                DispatchQueue.main.async(execute: {
                    self.deactivateView(self.view)
                    if status {
                        let controller : InvoiceVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.InvoiceVC) as! InvoiceVC
                        if let array = data {
                            controller.invoiceArray = array
                            if array.count <= 0 {
                                controller.message = message
                            }
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                    else{
                        Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                    }
                })
            })
    }
}

extension CheckOutVC : UITableViewDelegate, UITableViewDataSource {
    
    //    MARK: Tableview delegates and datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkOutArray.count + 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : CardCell?
        switch indexPath.row {
        case 0...(checkOutArray.count-1):
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CARD_CELL) as? CardCell
            cell?.configureCardCell(indexPath: indexPath)
            cell?.cardNumber.text = checkOutArray[indexPath.row]
            cell?.cardImageView.image = checkOutImageArray[indexPath.row]
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CHECKIN_CREDIT, for: indexPath as IndexPath) as! CheckInTableViewCell
            cell.backgroundColor = .clear
            cell.configureCell(indexPath: indexPath)
            if let num = Helper.GetBooking()?.cardNumber {
                cell.subTitle.text = num
            }
            else{
                cell.subTitle.text = "No pre authorized card available"
            }
                cell.lbl_expiry.text = ""

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CHECKIN_DATES, for: indexPath as IndexPath) as! CheckInTableViewCell
            cell.backgroundColor = .clear
            cell.configureCell(indexPath: indexPath)
            var arrive = ""
            var depart = ""
            if let arrival = Helper.GetBooking()?.arrival {
                arrive = arrival
            }
            if let departure = Helper.GetBooking()?.departure {
                depart = departure
            }
            cell.subTitle.text = "\(arrive) - \(depart)"
            return cell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.CARD_CHECKOUT) as? CardCell
            cell?.checkOutBtn.addTarget(self, action: #selector(checkOutAction(_:)), for: .touchUpInside)
            
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case checkOutArray.count:
//            return 65
//        default:
            return 85
//        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0://View Bill
            Helper.SaveTempBooking(Helper.GetBooking())
            self.getBill()
//            Helper.showAlert(sender: self, title: "", message: "In progress")
            break
        default://Select a Payment Method
//            let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.EDIT_CARD) as! EditCardVC
//            objDirection.titleBarText = checkOutArray[indexPath.row]
//            DispatchQueue.main.async(execute: {
//                self.navigationController?.pushViewController(objDirection, animated: true)
//            })
            break
        }
    }
    
}

extension CheckOutVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = Device.SCREEN_WIDTH/2 //Display Two elements in a row.
        collectionViewSize.height = Device.SCREEN_WIDTH/2 - Device.SCREEN_WIDTH/4
        menuCollectionViewHeightConstraint.constant = collectionViewSize.height + 40
        return collectionViewSize
    }
    
    // MARK: - UICollectionView Delegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return menuArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER.DASHBOARD, for: indexPath as IndexPath) as! DashboardCell
        cell.configureCell(indexPath: indexPath, menuObj:menuArray[indexPath.row], placeholderImage: menuPlaceholderImageArray[indexPath.row])
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0://Directions To Airport
            let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DIRECTIONS_MENU) as! DirectionsMenuVC
            objDirection.titleBarText = menuArray[indexPath.row].label!
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(objDirection, animated: true)
            })
        default://Request Car
            let objDirection = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DIRECTIONS_MENU) as! DirectionsMenuVC
            objDirection.titleBarText = menuArray[indexPath.row].label!
            objDirection.isRequestForCar = true
            DispatchQueue.main.async(execute: {
                self.navigationController?.pushViewController(objDirection, animated: true)
            })
        }
    }
}

