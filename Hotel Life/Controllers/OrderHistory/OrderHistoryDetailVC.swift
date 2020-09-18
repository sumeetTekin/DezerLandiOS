//
//  OrderHistoryDetailVC.swift
//  Resort Life
//
//  Created by Amit Verma on 07/02/19.
//  Copyright © 2019 jasvinders.singh. All rights reserved.
//

import UIKit

class OrderHistoryDetailVC: BaseViewController,SelectChairVCDelegate{
    
    
    var scrnType : SubMenuDataType?
    var selectedmenu : Menu?
    
    var orderId : String?
    var orderMode : Int?
    var orders:OrderDetailsData?
    var titleBarText : String? = ""
    var reservation : ReservationModel?
    var alreadyReserved = false
    var selectedMenu : Menu?
    var screenType : SubMenuDataType = .reservation
    var showConfirmation = true
    var orderTotal : Float = 0
    var showDate = true
    var showTime = false
    var showChair = true
    var showTax = false
    var showPromo = false
    var showGender = false
    var showCancel = true
    var showModify = true
    var customCancelDialog = false
    var showDuration = false
    var chairCell = 0
    var dateTimeCell = 0
    var taxCell = 0
    var modifyCell = 0
    var cancelCell = 0
    //    var callCell = 0
    var genderCell = 0
    var durationCell = 0
    var firstCellIndex = 0
    
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var constraint_total: NSLayoutConstraint!
    @IBOutlet weak var tbl_list: UITableView!
    @IBOutlet weak var btn_RepeatOrder: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userId = Helper.ReadUserObject()?.userId{
            getOrderDetails(userID: userId)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        tbl_list.rowHeight = UITableViewAutomaticDimension
        tbl_list.estimatedRowHeight = 200
        Helper.logScreen(screenName: "Item Order screen", className: "OrderVC")
        self.navigationItem.title = titleBarText
        btn_continue.setTitle(BUTTON_TITLE.Continue, for: .normal)
        let btn_back = UIBarButtonItem.init(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backAction(_:)))
        self.navigationItem.leftBarButtonItem = btn_back
        self.updateTaxAndPromocode()
        if reservation?.gender != nil {
            showGender = true
        }
        
        self.checkCells()
        
        if (orderMode == 3 || orderMode == 9){
            btn_RepeatOrder.isHidden = false
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if showConfirmation {
            showConfirmationAlert()
        }
    }
    func checkCells() {
        showTax = reservation?.tax != nil ? true : false
        showPromo = reservation?.promocode != nil ? true : false
        if let taxPromo = reservation?.taxPromoTotal {
            showTax = taxPromo.sub_total > Float(0) ? true : false
        }
        switch screenType {
        case .submenu_selection:
            showDuration = reservation?.instructor != nil ? true : false
        default:
            showDuration =  false
        }
        
        if let customDialog = selectedMenu?.items_attributes?.hide_cancel, customDialog == true {
            customCancelDialog = customDialog
        }
        if let hide_modify = selectedMenu?.items_attributes?.hide_modify {
            showModify = !hide_modify
            showCancel = checkForShowCancel()
        }
        
        dateTimeCell = showDate ? 1 : showTime ? 1 : 0
        chairCell = showChair ? 1 : 0
        taxCell = showTax ? 1 : showPromo ? 1 : 0
        genderCell = showGender ? 1 : 0
        cancelCell = showCancel ? 1 : 0
        modifyCell = showModify ? 1 : 0
        durationCell = showDuration ? 1 : 0
        firstCellIndex = dateTimeCell == 1 ? (genderCell == 1 ? 2 : 1) : (chairCell == 1 ? (genderCell == 1 ?2 : 1) : (genderCell == 1 ? 1 : 0))
        
    }
    func checkForShowCancel() -> Bool{
        if let orderDate = reservation?.order_date {
            let maxTime : Double = 5 * 60
            let currentDate = Helper.getCurrentDateTime()
            let interval = currentDate.timeIntervalSince(orderDate) < 0 ? 0 : currentDate.timeIntervalSince(orderDate)
            if interval > maxTime {
                return false
            }
            else{
                self.perform(#selector(hideCancelBtn), with: nil, afterDelay: maxTime - interval)
            }
        }
        return true
    }
    @objc func hideCancelBtn() {
        showCancel = false
        cancelCell = showCancel ? 1 : 0
        tbl_list.reloadData()
    }
    func showConfirmationAlert() {
        guard let alertTitle = reservation?.alertTitle else {
            return
        }
        guard let alertMessage = reservation?.alertMessage else {
            return
        }
        if alertMessage == "" || alertTitle == "" {
            return
        }
        else{
            self.showConfirmationDialog(title: alertTitle, message: alertMessage)
            self.showConfirmation = false
        }
        
    }
    
    func updateTaxAndPromocode() {
        if let model = reservation {
            self.reservation?.taxPromoTotal = TaxPromoTotal().calculateTaxesForReservation(reservation : model)
            if let total = reservation?.taxPromoTotal?.order_total {
                orderTotal = total
            }
            self.lbl_total.text = String.init(format: "$%.2f", orderTotal)
            switch screenType {
            case .submenu_selection:
                if orderTotal == 0 {
                    self.constraint_total.constant = 0
                }
            default:
                self.constraint_total.constant = 135
            }
        }
    }
    
    func getOrderDetails(userID:String){
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
        })
        let bizz = BusinessLayer()
        bizz.getOrderDetails(userId: orderId!, params: [:]) { (success, response, message) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            if success{
                if let allOrders = response?.data{
                    DispatchQueue.main.async(execute: {
                        self.orders = allOrders
                        if allOrders.department?.department_type == DEPARTMENTTYPE.QUANTITY_SELECTION && allOrders.department?.items_attributes?.instant_order == true{
                            self.orderMode = 3
                        }else if allOrders.department?.department_type == DEPARTMENTTYPE.TAB{
                            self.orderMode = 9
                        }
                        
                        if (self.orderMode == 3 || self.orderMode == 9){
                            self.btn_RepeatOrder.isHidden = false
                        }
                        print(allOrders)
                        self.reservation = self.orders?.reservetionModel
                        self.updateTaxAndPromocode()
                        self.checkCells()
                        self.tbl_list.reloadData()
                    })
                }
            } else {
                DispatchQueue.main.async(execute: {
                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
                })
            }
        }
        
    }
    
    @IBAction func CancelAction(_ sender: UIButton) {
        if customCancelDialog {
            let objAlert = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier: REUSABLEVIEWS.CancelAlert) as! CancelAlert
            self.definesPresentationContext = true
            objAlert.modalPresentationStyle = .overCurrentContext
            objAlert.view.backgroundColor = .clear
            //            objAlert.lbl_message.textColor = .white
            objAlert.lbl_title.text = self.titleBarText
            var mobile_number = ""
            if let number = self.selectedMenu?.mobile_number {
                mobile_number = number
            }
            objAlert.setClickableText(completeText: "Spa reservations cannot be cancelled online as per the spa rules. Please call \(mobile_number) to request a cancellation.", clickableText: mobile_number)
            
            //            objAlert.lbl_title.text = "Title"
            // yes action pending
            self.present(objAlert, animated: false) {
            }
            return
        }
        else{
            self.cancelReservation()
        }
    }
    func cancelReservation() {
        DispatchQueue.main.async(execute: {
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject = BusinessLayer()
        bizObject.cancelReservation(appointmentId: (reservation?._id)!, {(status , response) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if status {
                    for viewController in (self.navigationController?.viewControllers)! {
                        if viewController is BaseTabBarVC {
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
            })
        })
    }
    
    
    @IBAction func repeatOrderAction(_ sender: Any) {
        self.hitAppinymentForOrderApi()
    }
    
    
    @IBAction func continueAction(_ sender: UIButton) {
        //self.showSelectChareView()
       self.backToMainView()
    }
    
    private func hitAppinymentForOrderApi(){
        self.reorder(id: orderId)
    }
    
    private func showSelectChareView(model : AlohaOrder, reservatioModel:ReservationModel?){
        let objUpgrade = Helper.getMainStoryboard().instantiateViewController(withIdentifier: "SelectChairVC") as! SelectChairVC
        objUpgrade.delegate = self
        objUpgrade.showRoomForOrder = true
        objUpgrade.alohaOrderModel =  model
        //objUpgrade.alreadyReserved = alreadyReserved
        objUpgrade.reservationModel = reservatioModel
        objUpgrade.alertText = ALERTSTRING.ROOM_NUMBER
        objUpgrade.modalPresentationStyle = .overCurrentContext
        objUpgrade.modalTransitionStyle = .crossDissolve
        objUpgrade.view.backgroundColor = .clear
        DispatchQueue.main.async(execute: {
            self.navigationController?.present(objUpgrade, animated: true, completion: nil)
        })
    }
    
    
    func selectedChair(model: ReservationModel, controller: UIViewController) {
        
    }
    
    func selectedRoom(model: ReservationModel, controller: UIViewController) {
        controller.dismiss(animated: true, completion: {
        })
    }
    
    func fillRoom(alohaOrderModel: AlohaOrder, reservationModel: ReservationModel, controller: UIViewController) {
        controller.dismiss(animated: true, completion: {
            
            
            let objPreviewVC : AlohaOrderPreview = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.AlohaOrderPreview) as! AlohaOrderPreview
            objPreviewVC.order = alohaOrderModel
            objPreviewVC.order.reservationModel = alohaOrderModel.reservationModel
            objPreviewVC.screenType = self.scrnType!
            objPreviewVC.selectedMenu = self.selectedmenu
            objPreviewVC.titleBarText = self.selectedmenu?.label
            DispatchQueue.main.async(execute: {
                UIApplication.topViewController()?.navigationController?.pushViewController(objPreviewVC, animated: true)
            })
            
        })
    }
    
    func selectedQuantity(quantity: Int) {
        
    }
    
    func discription(model: ReservationModel, controller: UIViewController) {
        
    }
    
    
    private func reorder(id : String?) {
        UserDefaults.standard.set(true, forKey: "isFromOrderHistoryDetailVC")
        BusinessLayer().getReorderMenuDetail(appointmentId: id) { (status, message, order, selectedMenu) in
            let obj = BusinessLayer()
            DispatchQueue.main.async {
                Helper.showLoader(title: LOADER_TEXT.loading)
            }
            if let menuArr = order?.alohaMenu {
                self.scrnType = SubMenuDataType.tabs_quantity_selection
                self.selectedmenu = selectedMenu
                
                if let mode = self.orderMode {
                    self.scrnType = Helper.getScreenType(orderMode: mode)
                }
                var beachLocation = false
                if order?.orderMode == 7{
                    beachLocation = true
                }else {
                    beachLocation = false
                }
                obj.calculateAlohaTax(arr: menuArr, orderMode : Helper.getOrderMode(screenType: self.scrnType!, beachLocation: beachLocation)) { (status, alohaOrder, message) in
                    
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
                                    //if item.is_drink == true {
                                        if let alohaMenus = alohaOrder.alohaMenu {
                                            for menu in alohaMenus {
                                                if menu.posItemId == item.posItemId {
                                                    menu.is_drink = item.is_drink
                                                }
                                            }
                                        }
                                    //}
                                }
                                
                                
                            }
                            
                            if self.orderMode == 3 && alohaOrder.roomNumber == ""{
                                DispatchQueue.main.async {
                                    self.showSelectChareView(model: alohaOrder, reservatioModel: order?.reservationModel)
                                }
                                
                            }
                            
                            else{
                                
                                let objPreviewVC : AlohaOrderPreview = Helper.getCustomReusableViewsStoryboard().instantiateViewController(withIdentifier:REUSABLEVIEWS.AlohaOrderPreview) as! AlohaOrderPreview
                                alohaOrder.orderMode = self.orderMode
                                objPreviewVC.order = alohaOrder
                                objPreviewVC.order.reservationModel = order?.reservationModel
                                objPreviewVC.screenType = self.scrnType!
                                objPreviewVC.selectedMenu = selectedMenu
                                objPreviewVC.titleBarText = selectedMenu?.label
                                DispatchQueue.main.async(execute: {
                                    UIApplication.topViewController()?.navigationController?.pushViewController(objPreviewVC, animated: true)
                                })
                                
                            }
                            
                        }else{
                             if self.orderMode == 3/*9*/ {
                                Helper.showalert(response: "Due to an error you cannot repeat an order from the history, Please  place the order from main menu.")
                                
                            }
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
    
    
    private func backToMainView(){
        
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController is BaseTabBarVC {
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
    
    @objc func modifyAction(_ sender: UIButton) {
        OrderController.shared.modifyOrder(menu_item: selectedMenu, reservation_model: reservation, screenType: screenType, viewController: self)
    }
    
    @objc func callAction(_ sender: UIButton) {
        
        var str = ""
        if let country_code = self.reservation?.country_code {
            str = str.appending(country_code)
        }
        if let mobile_number = self.reservation?.mobile_number {
            str = str.appending(mobile_number)
        }
        Helper.call(number: str)
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //        for viewController in (self.navigationController?.viewControllers)! {
        //            if viewController is BaseTabBarVC {
        //                DispatchQueue.main.async(execute: {
        //                    self.navigationController?.popToViewController(viewController, animated: true)
        //                })
        //                return
        //            }
        //        }
        //        let objDashboard = Helper.getMainStoryboard().instantiateViewController(withIdentifier: STORYBOARD.DASHBOARD) as! BaseTabBarVC
        //        DispatchQueue.main.async(execute: {
        //            self.navigationController?.pushViewController(objDashboard, animated: true)
        //        })
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
    
    func getTabsDepartmentMenuItems(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Tab]?) -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status, message, tabsArray) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
            })
            if status {
                if tabsArray.count > 0 {
                    completionHandlar(true,message,tabsArray)
                }else{
                    completionHandlar(true,message, nil)
                }
            }
            else{
                Helper.showAlert(sender: self, title: "Error", message: message)
            }
            
        })
        
    }
    
    func getDepartment(departmentId : String , _ completionHandlar : @escaping (Bool, String, [Tab]?) -> Void) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.activateView(self.view, loaderText: LOADER_TEXT.loading)
        })
        let bizObject = BusinessLayer()
        bizObject.getTabs(departmentId: departmentId, { (status,message, deptItemArray) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.deactivateView(self.view)
                if status {
                    completionHandlar(true, message, deptItemArray)
                }
                else{
                    Helper.showAlert(sender: self, title: "Error", message: message)
                }
            })
            
            
        })
        
    }
}

extension OrderHistoryDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        if taxCell == 1 {
    //            if let items = reservation?.items {
    //                if indexPath.row == (dateTimeCell + items.count + genderCell + taxCell) {
    //                    var height : CGFloat = 0
    //                    if let reservation = self.reservation {
    //                        let customHeight = Helper.getCellHeight(reservation: reservation)
    //                        height = customHeight
    //                    }
    //                    return height
    //                }
    //            }
    //        }
    //        return 65
    //    }
    
    func returnCount() -> Int{
        dateTimeCell = dateTimeCell + ((reservation?.items?.count) ?? 0)
        dateTimeCell = dateTimeCell + taxCell
        dateTimeCell = dateTimeCell + genderCell
        dateTimeCell = dateTimeCell + durationCell
        
       return (1 + dateTimeCell)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return returnCount()
        }
        else{
            //cancel + modify
            return   0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
            switch indexPath.row {
            // confirmation Cell
            case 0:
                if (reservation?.chair_number == "" || reservation?.chair_number == nil) && (reservation?.room_number == "" || reservation?.room_number == nil) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_ORDER, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_subTitle.text = reservation?.confirmation_number?.uppercased()
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_ORDER_CHAIR, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_subTitle.text = reservation?.confirmation_number?.uppercased()
                    if let chair = self.reservation?.chair_number {
                        cell.timeLabel.text = chair.uppercased()
                    }
                    else if let room_number = reservation?.room_number {
                        cell.timeLabel.text = room_number
                        cell.img_cellImage.image = #imageLiteral(resourceName: "roomNumberIcon")
                    }
                    return cell
                    
                }
            case dateTimeCell :
                if showDate == true && showTime == false {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DATE, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_subTitle.text = reservation?.appointment_date
                    return cell
                }
                else if showDate == true && showTime == true {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_DATE_TIME, for: indexPath as IndexPath) as! BookingDetailCell
                    cell.lbl_subTitle.text = reservation?.appointment_date
                    cell.timeLabel.text =  reservation?.appointment_time
                    return cell
                }else{
                    fallthrough
                }
            case dateTimeCell + genderCell :
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_QUANTITY, for: indexPath as IndexPath) as! BookingDetailCell
                cell.reservationType.text = "Therapist"
                cell.lbl_quantity_price.text = reservation?.gender?.capitalized
                return cell
            case dateTimeCell + genderCell + durationCell :
                if showDuration {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_INSTRUCTOR_CELL, for: indexPath as IndexPath) as! BookingDetailCell
                    if let duration = reservation?.duration, duration != "" {
                        cell.lbl_duration.text = "\(TITLE.duration)\(duration)"
                    }
                    else {
                        cell.lbl_duration.text = ""
                    }
                    if let instructor = reservation?.instructor {
                        cell.lbl_instructor.text = "\(TITLE.instructor)\(instructor == true ? BUTTON_TITLE.Yes : BUTTON_TITLE.No)"
                    }
                    else {
                        cell.lbl_instructor.text = ""
                    }
                    return cell
                }
                else {
                    fallthrough
                }
                
            case (dateTimeCell + genderCell + durationCell)...(((reservation?.items?.count) ?? 0) + dateTimeCell + genderCell + durationCell) :
                // if we have date row also then we will have to add this 1
                switch screenType {
                case .service_selection, .submenu_selection:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_TOTAL, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    if let item = reservation?.items?[indexPath.row - (1 + dateTimeCell + genderCell + durationCell)] {
                        cell.reservationType.text = item.item_name
                        if let price = item.item_price {
                            if let actualPrice = Float(price) {
                                if actualPrice <= 0 {
                                    cell.reservationTotal.isHidden = true
                                }
                                else{
                                    cell.reservationTotal.isHidden = false
                                    cell.reservationTotal.text = "$\(price)"
                                }
                            }
                        }
                    }
                    return cell
                default :
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_QUANTITY, for: indexPath as IndexPath) as! BookingDetailCell
                    if let item = reservation?.items?[indexPath.row - (1 + dateTimeCell + genderCell + durationCell)] {
                        cell.setupCellFor(item : item, delegate : nil)
                    }
                    return cell
                }
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.TAX_CELL, for: indexPath as IndexPath) as! TaxCell
                
                cell.reservationModel = self.reservation
                cell.setupTaxesLabels()
                return cell
            }
        }
        else{
            switch indexPath.row {
            case 0:
                if showModify {
                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                    
                    cell.cancelBtn.addTarget(self, action: #selector(modifyAction(_:)), for: .touchUpInside)
                    cell.cancelBtn.setTitle(TITLE.Modify, for: .normal)
                    cell.cancelBtn.setTitleColor(UIColor.black, for: .normal)
                    cell.cancelBtn.setBackgroundImage(#imageLiteral(resourceName: "btn_turqoise"), for: .normal)
                    cell.cancelBtn.backgroundColor = COLORS.THEME_YELLOW_COLOR
                    return cell
                }
                else {
                    fallthrough
                }
                //                case 1:
                //                    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                //
                //                    cell.cancelBtn.addTarget(self, action: #selector(callAction(_:)), for: .touchUpInside)
                //                    cell.cancelBtn.setTitle(TITLE.Call, for: .normal)
                //                    cell.cancelBtn.setTitleColor(UIColor.black, for: .normal)
                //                    cell.cancelBtn.setBackgroundImage(#imageLiteral(resourceName: "btn_turqoise"), for: .normal)
                //                    cell.cancelBtn.backgroundColor = COLORS.THEME_YELLOW_COLOR
            //                    return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER.BOOKING_CANCEL, for: indexPath as IndexPath) as! BookingDetailCell
                
                cell.cancelBtn.addTarget(self, action: #selector(CancelAction(_:)), for: .touchUpInside)
                cell.cancelBtn.setTitle(BUTTON_TITLE.Cancel, for: .normal)
                cell.cancelBtn.setTitleColor(UIColor.white, for: .normal)
                cell.cancelBtn.backgroundColor = COLORS.DARKGREY_COLOR
                return cell
            }
        }
    }
}

//class OrderHistoryDetailVC: BaseViewController {
//
//
//    var orders:OrderDetailsData?
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var bottomView: UIView!
//    @IBOutlet weak var lbl_price: UILabel!
//    @IBOutlet weak var lbl_totalText: UILabel!
//    @IBOutlet weak var btn_confirm: UIButton!
//    //    var reservationModel : ReservationModel?
//
//    /*Header View Outlets*/
//
//    @IBOutlet weak var lblLocation: UILabel!
//    @IBOutlet weak var lblLocationValue: UILabel!
//
//    @IBOutlet weak var imageBeach: UIImageView!
//
//
//
//    /*Footer View Outlets*/
//
//    @IBOutlet weak var lblSubTotal: UILabel!
//    @IBOutlet weak var lblTolalDiscountValue: UILabel!
//    @IBOutlet weak var lblSubTotalAfterDiscount: UILabel!
//    @IBOutlet weak var lblServiceChargesValue: UILabel!
//    @IBOutlet weak var lblDelieverychargesValue: UILabel!
//    @IBOutlet weak var lblStatetextValue: UILabel!
//    @IBOutlet weak var lblCountyTaxValue: UILabel!
//
//    var orderId : String?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.rowHeight = UITableViewAutomaticDimension
//
//        if let userId = Helper.ReadUserObject()?.userId{
//            getOrderDetails(userID: userId)
//        }
//     }
//
//    func getOrderDetails(userID:String){
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.activateView(self.view, loaderText:LOADER_TEXT.loading)
//        })
//        let bizz = BusinessLayer()
//        bizz.getOrderDetails(userId: orderId!, params: [:]) { (success, response, message) in
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.deactivateView(self.view)
//            })
//            if success{
//                if let allOrders = response?.data{
//                    self.orders = allOrders
//                    print(allOrders)
//
//                    DispatchQueue.main.async(execute: {
//                        self.tableView.reloadData()
//                    })
//                }
//            } else {
//                DispatchQueue.main.async(execute: {
//                    Helper.showAlert(sender: self, title: ALERTSTRING.ERROR, message: message)
//                })
//            }
//        }
//
//    }
//
//
//}
