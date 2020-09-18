//
//  ConfirmationVC.swift
//  BeachResorts
//
//  Created by Vikas Mehay on 19/09/17.
//  Copyright © 2017 jasvinders.singh. All rights reserved.
//

import UIKit

class ConfirmationVC: BaseViewController {
    var navTitle : String? = ""
    var reservationModel : ReservationModel?
    
    @IBOutlet weak var tbl_items: UITableView!
    
    var showPromo = false
    var showOccasion = false
    var showDuration = false // shows duration in tennis court
    var showRoom = false// shows room number for restaurant reservation
    var selectedMenu : Menu?
    var roomCell = 0
    var promoCell = 0
    var occasionCell = 0
    var cancelCell = 1
    var modifyCell = 1
//    var callCell = 0
    var durationCell = 0
    var screenType : SubMenuDataType = .reservation
    var showConfirmationDailog = true
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.logScreen(screenName: "Reservations confirmation Screen", className: "ConfirmationVC")
        tbl_items.rowHeight = UITableViewAutomaticDimension
        tbl_items.estimatedRowHeight = 200
        showPromo = reservationModel?.promocode != nil ? true : false
        checkCell()
        updateTaxAndPromocode()
    }
    func checkCell() {
        if self.reservationModel?.occasion != nil && self.reservationModel?.occasion != "" {
            showOccasion = true
        }
        if self.reservationModel?.specialRequest != nil && self.reservationModel?.specialRequest != "" {
            showOccasion = true
        }
        if reservationModel?.instructor != nil{
            showDuration = true
        }
//        if self.screenType == .reservation {
//            self.showRoom = true
//        }
        promoCell = showPromo ? 1 : 0
        occasionCell = showOccasion ? 1 : 0
        durationCell =  showDuration ? 1 : 0
        if showRoom {
            roomCell = 1
        }
        
    }
    func updateTaxAndPromocode() {
        self.reservationModel?.taxPromoTotal = TaxPromoTotal().calculateTaxesForReservation(reservation : reservationModel!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = navTitle
        self.navigationController?.navigationBar.isHidden = false

        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if showConfirmationDailog {
            showConfirmationDailog = false
            showConfirmationAlert()
        }
    }
    
    func showConfirmationAlert() {
        guard let alertTitle = reservationModel?.alertTitle else {
            return
        }
        guard let alertMessage = reservationModel?.alertMessage else {
            return
        }
        if alertMessage == "" || alertTitle == "" {
            return
        }
        else{
            self.showConfirmationDialog(title: alertTitle, message: alertMessage)
        }
    }
    
    
    @IBAction func continueAction(_ sender: UIButton) {
        self.goBackToSubViewVC()
    }
    @objc func callAction(_ sender: UIButton) {
        var str = ""
        if let country_code = self.reservationModel?.country_code {
            str = str.appending(country_code)
        }
        if let mobile_number = self.reservationModel?.mobile_number {
            str = str.appending(mobile_number)
        }
        let callStr = "tel://\(str)"
        if let url = URL(string: callStr) {
            UIApplication.shared.openURL(url)
            //            kAppDelegate.open(url, options: [:], completionHandler: nil)
        }
    }
    @objc func modifyAction(_ sender: Any) {
        let controllerDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
        controllerDateTime.titleBarText = self.navTitle
        
//        let selectedMenu = Menu()
        self.selectedMenu?.order_Id = reservationModel?._id
        self.selectedMenu?.module_id = reservationModel?.module_id
        self.selectedMenu?.department_Id = reservationModel?.department_id
        controllerDateTime.reservationModel = reservationModel
        controllerDateTime.selectedMenu = self.selectedMenu!
        controllerDateTime.showTimeView = true
//        controllerDateTime.showPersonView = true
//        controllerDateTime.showSpecialRequest = true
        controllerDateTime.tableCellType = .checkboxCell
        controllerDateTime.screenType = .reservation
        controllerDateTime.alreadyReserved = true
        controllerDateTime.promocode = reservationModel?.promocode
        
        if let _ = reservationModel?.instructor{
            controllerDateTime.showDuration = true
            controllerDateTime.showPersonView = false
            controllerDateTime.showSpecialRequest = false
        }
        else {
            controllerDateTime.showPersonView = true
            controllerDateTime.showSpecialRequest = true
            controllerDateTime.showDuration = false
        }
        DispatchQueue.main.async(execute: {
            self.deactivateView(self.view)
            self.navigationController?.pushViewController(controllerDateTime, animated: true)
        })
//        let controllerDateTime : DateTimeVC = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.DateTimeVC) as! DateTimeVC
//        controllerDateTime.titleBarText = self.menu_item?.label
//        controllerDateTime.selectedMenu = self.menu_item!
//        controllerDateTime.showTimeView = true
//
//        if self.menu_item?.items_attributes?.is_restaurant == false {
//            controllerDateTime.showDuration = true
//            controllerDateTime.showPersonView = false
//            controllerDateTime.showSpecialRequest = false
//        }
//        else {
//            controllerDateTime.showPersonView = true
//            controllerDateTime.showSpecialRequest = true
//            controllerDateTime.showDuration = false
//        }
//
//        controllerDateTime.tableCellType = .checkboxCell
//        controllerDateTime.screenType = .reservation
//
//        if controllerDateTime.selectedMenu.module_id == "" {
//            controllerDateTime.selectedMenu.module_id = self.menu_item?.department_Id
//        }
//        DispatchQueue.main.async(execute: {
//            if let controller = self.viewController as? BaseViewController {
//                controller.deactivateView(controller.view)
//            }
//            self.viewController.navigationController?.pushViewController(controllerDateTime, animated: true)
//        })
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })

        let bizObject = BusinessLayer()
        bizObject.cancelReservation(appointmentId: (reservationModel?._id)!, {(status , response) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            if status {
                self.goBackToSubViewVC()
            }
        })
    }
    
    func goBackToSubViewVC () {
        for viewController in (self.navigationController?.viewControllers)! {
            
            if viewController is SubMenuVC{
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popToViewController(viewController, animated: true)
                })
                return
            }
        }
        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        DispatchQueue.main.async(execute: {
            self.navigationController?.pushViewController(objDashboard, animated: true)
        })
    }
    
    func showConfirmationDialog(title : String, message : String) {
        DispatchQueue.main.async(execute: {
            let objAlert = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.ALERT) as! AlertView
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            
            objAlert.set(title: title, message: message, done_title: BUTTON_TITLE.Continue)
            self.present(objAlert, animated: false) {
            }
        })
    }
    
    @objc func backAction (_ sender : UIButton) {
        goBackToSubViewVC()
    }

}
extension ConfirmationVC: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // date time + number of people
        return section == 0 ? roomCell + 1 + 1 + durationCell : occasionCell + promoCell  + modifyCell + cancelCell

    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if showDuration  {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_ORDER_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_subTitle.text = reservationModel?.confirmation_number?.uppercased()
                    if let chair = self.reservationModel?.chair_number {
                        cell.timeLabel.text = chair.uppercased()
                    }
                    else if let room_number = reservationModel?.room_number {
                        cell.timeLabel.text = room_number
                        cell.img_cellImage.image = #imageLiteral(resourceName: "roomNumberIcon")
                    }
                    return cell
                }
                else if  showRoom {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                     if let room_number = reservationModel?.room_number {
                        cell.lbl_title.text = TITLE.RoomNumber
                        cell.lbl_subTitle.text = room_number
                        cell.img_cellImage.image = #imageLiteral(resourceName: "roomNumberIcon")
                    }
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DATE_TIME, for: indexPath as IndexPath) as! BookingDetailCell
                        cell.lbl_subTitle.text = reservationModel?.appointment_date
                        cell.timeLabel.text =  reservationModel?.appointment_time

                    return cell
                }
            case 1:
                if showDuration || showRoom {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DATE_TIME, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_subTitle.text = reservationModel?.appointment_date
                    cell.timeLabel.text =  reservationModel?.appointment_time
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_NUMBER, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    cell.lbl_title.text = "Number of People"
                    if let people = reservationModel?.number_of_people {
                        cell.lbl_count.text = "\(people)"
                    }
                    return cell
                }
            case 2:
                if showDuration {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_INSTRUCTOR_CELL, for: indexPath as IndexPath) as! BookingDetailCell
                    if let duration = reservationModel?.duration, duration != "" {
                        cell.lbl_duration.text = "\(TITLE.duration)\(duration)"
                    }
                    else {
                        cell.lbl_duration.text = ""
                    }
                    if let instructor = reservationModel?.instructor {
                        cell.lbl_instructor.text = "\(TITLE.instructor)\(instructor == true ? BUTTON_TITLE.Yes : BUTTON_TITLE.No)"
                    }
                    else {
                        cell.lbl_instructor.text = ""
                    }
                    return cell
                }
                else if showRoom {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_NUMBER, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    cell.lbl_title.text = "Number of People"
                    if let people = reservationModel?.number_of_people {
                        cell.lbl_count.text = "\(people)"
                    }
                    return cell
                }
                else {
                    fallthrough
                }
            case 3:
                if showDuration {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_TOTAL, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.reservationType.text = navTitle
                    return cell
                }
                fallthrough
            default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.cancelBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
                    cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                    cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                    return cell
            }
        }
        else {
            switch indexPath.row {
            case 0:
                if showOccasion {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_OCCASION, for: indexPath as IndexPath) as! BookingDetailCell
                    if let occasion = self.reservationModel?.occasion {
                        cell.reservationType.text = occasion
                    }
                    else{
                        cell.constraint_occasion.constant = 0
                    }
                    if let req =  self.reservationModel?.specialRequest {
                        cell.lbl_quantity_price.text = req
                    }
                    else{
                        cell.constraint_specialRequest.constant = 0
                    }
                    return cell
                }
                else if showPromo {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.TAX_CELL, for: indexPath as IndexPath) as! TaxCell
                    cell.reservationModel = self.reservationModel
                    cell.setupPromocodeLabel()
                    return cell
                }
                else{
                    fallthrough
                }
            case promoCell :
                if showPromo && showOccasion {
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.TAX_CELL, for: indexPath as IndexPath) as! TaxCell
                cell.reservationModel = self.reservationModel
                cell.setupPromocodeLabel()
                return cell
                }
                fallthrough
            case 0...promoCell + occasionCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                cell.cancelBtn.addTarget(self, action: #selector(modifyAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(TITLE.Modify, for: .normal)
                cell.cancelBtn.setTitleColor(UIColor.black, for: .normal)
                cell.cancelBtn.setBackgroundImage(#imageLiteral(resourceName: "btn_turqoise"), for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.THEME_YELLOW_COLOR
                return cell
//            case promoCell + occasionCell + callCell :
//                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
//                cell.cancelBtn.addTarget(self, action: #selector(callAction(_:)), for: .touchUpInside)
//                cell.cancelBtn.setTitle(TITLE.Call, for: .normal)
//                cell.cancelBtn.setTitleColor(UIColor.black, for: .normal)
//                cell.cancelBtn.setBackgroundImage(#imageLiteral(resourceName: "btn_turqoise"), for: .normal)
//                cell.cancelBtn.backgroundColor = COLORS.THEME_YELLOW_COLOR
//                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                cell.cancelBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            }
        }
    }
}

